// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

/// Service audio utilisant le Web Audio API directement.
/// Génère des sons sans fichiers audio : chimes de phase + drone ambient.
class SoundService {
  static final SoundService instance = SoundService._();
  SoundService._();

  js.JsObject? _ctx;
  js.JsObject? _ambientMasterGain;
  final List<js.JsObject> _ambientOscs = [];
  bool _ambientOn = false;

  bool get ambientOn => _ambientOn;

  js.JsObject? _getCtx() {
    try {
      if (_ctx == null) {
        final ctor = js.context['AudioContext'] ?? js.context['webkitAudioContext'];
        if (ctor == null) return null;
        _ctx = js.JsObject(ctor as js.JsFunction);
      }
      if (_ctx!['state'] == 'suspended') {
        _ctx!.callMethod('resume', []);
      }
      return _ctx;
    } catch (_) {
      return null;
    }
  }

  double _now(js.JsObject ctx) => (ctx['currentTime'] as num).toDouble();

  /// Joue un chime doux au changement de phase.
  /// Fréquences : 528 Hz (inspire), 396 Hz (expire), 417 Hz (rétention).
  void playChime(String phaseLabel) {
    final ctx = _getCtx();
    if (ctx == null) return;
    final now = _now(ctx);
    final label = phaseLabel.toLowerCase();
    final freq = label.contains('insp')
        ? 528.0
        : label.contains('exp')
            ? 396.0
            : 417.0;
    _playBell(ctx, freq, now, 0.08, 2.0);
  }

  void _playBell(
    js.JsObject ctx,
    double freq,
    double startTime,
    double peakGain,
    double duration,
  ) {
    try {
      final osc = ctx.callMethod('createOscillator') as js.JsObject;
      final gain = ctx.callMethod('createGain') as js.JsObject;
      final gainParam = gain['gain'] as js.JsObject;

      osc['type'] = 'sine';
      (osc['frequency'] as js.JsObject)['value'] = freq;
      gainParam['value'] = peakGain;

      osc.callMethod('connect', [gain]);
      gain.callMethod('connect', [ctx['destination']]);
      osc.callMethod('start', [startTime]);
      gainParam.callMethod('exponentialRampToValueAtTime', [0.001, startTime + duration]);
      osc.callMethod('stop', [startTime + duration]);
    } catch (_) {}
  }

  /// Démarre le drone ambient (60 Hz + 432 Hz + 864 Hz).
  void startAmbient() {
    if (_ambientOn) return;
    final ctx = _getCtx();
    if (ctx == null) return;
    _ambientOn = true;
    final now = _now(ctx);

    _ambientMasterGain = ctx.callMethod('createGain') as js.JsObject;
    (_ambientMasterGain!['gain'] as js.JsObject)['value'] = 0.0;
    _ambientMasterGain!.callMethod('connect', [ctx['destination']]);
    (_ambientMasterGain!['gain'] as js.JsObject)
        .callMethod('linearRampToValueAtTime', [1.0, now + 3.0]);

    _spawnOsc(ctx, 60.0, 0.06);
    _spawnOsc(ctx, 432.0, 0.025);
    _spawnOsc(ctx, 864.0, 0.01);
  }

  void _spawnOsc(js.JsObject ctx, double freq, double vol) {
    try {
      final now = _now(ctx);
      final osc = ctx.callMethod('createOscillator') as js.JsObject;
      final gain = ctx.callMethod('createGain') as js.JsObject;

      osc['type'] = 'sine';
      (osc['frequency'] as js.JsObject)['value'] = freq;
      (gain['gain'] as js.JsObject)['value'] = vol;

      osc.callMethod('connect', [gain]);
      gain.callMethod('connect', [_ambientMasterGain]);
      osc.callMethod('start', [now]);

      _ambientOscs.add(osc);
    } catch (_) {}
  }

  /// Arrête le drone ambient avec un fade-out de 2.5s.
  void stopAmbient() {
    if (!_ambientOn || _ambientMasterGain == null) return;
    _ambientOn = false;
    final ctx = _getCtx();
    if (ctx == null) return;
    final now = _now(ctx);

    try {
      (_ambientMasterGain!['gain'] as js.JsObject)
          .callMethod('linearRampToValueAtTime', [0.0, now + 2.5]);
      for (final osc in _ambientOscs) {
        osc.callMethod('stop', [now + 2.5]);
      }
    } catch (_) {}

    _ambientOscs.clear();
    _ambientMasterGain = null;
  }

  void toggleAmbient() {
    if (_ambientOn) {
      stopAmbient();
    } else {
      startAmbient();
    }
  }

  void dispose() {
    stopAmbient();
  }
}
