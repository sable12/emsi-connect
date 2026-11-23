import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class MultimediaPage extends StatefulWidget {
  const MultimediaPage({super.key});

  @override
  State<MultimediaPage> createState() => _MultimediaPageState();
}

class _MultimediaPageState extends State<MultimediaPage> {
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  XFile? _image;
  int? _imageSize; // Taille de l'image en octets (XFile.length())
  String? _audioPath;
  bool _recording = false;
  bool _busy = false;

  Timer? _recordTimer;
  int _recordDuration = 0; // Durée de l'enregistrement en secondes

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes octets';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} Ko ($bytes octets)';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} Mo ($bytes octets)';
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> _chooseImage(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final XFile? selected = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );
      if (!mounted) return;
      if (selected == null) {
        _message('Sélection annulée.');
      } else {
        // Étudier et récupérer la taille du fichier via XFile.length()
        final size = await selected.length();
        if (!mounted) return;
        setState(() {
          _image = selected;
          _imageSize = size;
        });
      }
    } catch (e) {
      _message('Impossible de récupérer l’image : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
      _imageSize = null;
    });
    _message('Image effacée.');
  }

  Future<void> _startRecording() async {
    if (_busy || _recording) return;
    setState(() => _busy = true);
    try {
      // Sur mobile, permission_handler permet de gérer le refus et l'ouverture des réglages
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final status = await Permission.microphone.request();

        // Gestion du refus définitif avec bouton pour ouvrir les réglages
        if (status.isPermanentlyDenied) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Microphone définitivement refusé. Veuillez l’activer dans les réglages de l’appareil.',
              ),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Réglages',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
          return;
        }

        if (!status.isGranted) {
          _message('Microphone non autorisé.');
          return;
        }
      }

      if (!await _recorder.hasPermission()) {
        _message('Autorisation microphone indisponible.');
        return;
      }

      // Chemin de fichier pour Android/iOS.
      // Sur le Web, record utilise une autre gestion du média.
      if (kIsWeb) {
        _message('Enregistrement à tester sur Android/iOS.');
        return;
      }

      final path = '${Directory.systemTemp.path}/question_emsi.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      if (mounted) {
        // Démarrage du compteur de durée
        _recordDuration = 0;
        _recordTimer?.cancel();
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) {
            setState(() => _recordDuration++);
          }
        });

        setState(() => _recording = true);
      }
    } catch (e) {
      _message('Enregistrement impossible : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _stopRecording() async {
    if (!_recording) return;
    // Arrêt du minuteur
    _recordTimer?.cancel();
    _recordTimer = null;

    try {
      final path = await _recorder.stop();
      if (!mounted) return;
      setState(() {
        _recording = false;
        _audioPath = path;
      });
      _message(
        path == null
            ? 'Aucun fichier enregistré.'
            : 'Question vocale enregistrée (${_formatDuration(_recordDuration)}).',
      );
    } catch (e) {
      _message('Erreur lors de l’arrêt : $e');
      if (mounted) setState(() => _recording = false);
    }
  }

  Future<void> _playAudio() async {
    final path = _audioPath;
    if (path == null) return;
    try {
      await _player.stop();
      await _player.play(DeviceFileSource(path));
    } catch (e) {
      _message('Lecture impossible : $e');
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final image = _image;
    final imageSize = _imageSize;
    final audioPath = _audioPath;

    // PopScope empêche de quitter la page pendant un enregistrement actif
    // et propose d'arrêter proprement l'enregistrement si l'utilisateur confirme.
    return PopScope(
      canPop: !_recording,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (dialogCtx) => AlertDialog(
            title: const Text('Enregistrement en cours'),
            content: const Text(
              'Un enregistrement vocal est actuellement actif. '
              'Voulez-vous l’arrêter et quitter la page ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx, false),
                child: const Text('Continuer l’enregistrement'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogCtx, true),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Arrêter et quitter'),
              ),
            ],
          ),
        );

        if (shouldExit == true && context.mounted) {
          await _stopRecording();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Espace multimédia')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Image',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed:
                      _busy ? null : () => _chooseImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Prendre une photo'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed:
                      _busy ? null : () => _chooseImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galerie'),
                ),
                if (image != null)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 44),
                    ),
                    onPressed: _busy ? null : _clearImage,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text(
                      'Effacer l’image',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        image.path,
                        height: 190,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(image.path),
                        height: 190,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nom : ${image.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (imageSize != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Taille : ${_formatBytes(imageSize)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const Divider(height: 40),
            const Text(
              'Question vocale',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _busy
                      ? null
                      : (_recording ? _stopRecording : _startRecording),
                  icon: Icon(_recording ? Icons.stop : Icons.mic),
                  label: Text(_recording ? 'Arrêter' : 'Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    backgroundColor: _recording ? Colors.red : null,
                    foregroundColor: _recording ? Colors.white : null,
                  ),
                ),
                if (_recording)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.fiber_manual_record,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatDuration(_recordDuration),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (audioPath != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 44),
                ),
                onPressed: _playAudio,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Écouter l’enregistrement'),
              ),
            ],
            if (_busy) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
