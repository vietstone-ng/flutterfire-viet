// ignore_for_file: require_trailing_commas
// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

/// Specifies custom configurations for your Cloud Firestore instance.
///
/// You must set these before invoking any other methods.
@immutable
class Settings {
  /// Creates an instance for these [Settings].
  const Settings({
    this.persistenceEnabled,
    this.host,
    this.sslEnabled,
    this.cacheSizeBytes,
    this.ignoreUndefinedProperties = false,
    this.experimentalForceLongPolling = false,
    this.experimentalAutoDetectLongPolling = false,
  });

  /// Constant used to indicate the LRU garbage collection should be disabled.
  ///
  /// Set this value as the cacheSizeBytes on the settings passed to the Firestore instance.
  static const int CACHE_SIZE_UNLIMITED = -1;

  /// Attempts to enable persistent storage, if possible.
  /// This setting has no effect on Web, for Web use [FirebaseFirestore.enablePersistence] instead.
  final bool? persistenceEnabled;

  /// The hostname to connect to.
  final String? host;

  /// Whether to use SSL when connecting.
  final bool? sslEnabled;

  /// An approximate cache size threshold for the on-disk data.
  ///
  /// If the cache grows beyond this size, Firestore will start removing data that hasn't
  /// been recently used. The size is not a guarantee that the cache will stay
  /// below that size, only that if the cache exceeds the given size, cleanup
  /// will be attempted.
  ///
  /// The default value is 40 MB. The threshold must be set to at least 1 MB,
  /// and can be set to [Settings.CACHE_SIZE_UNLIMITED] to disable garbage collection.
  final int? cacheSizeBytes;

  /// Whether to skip nested properties that are set to undefined during object serialization.
  ///
  /// If set to true, these properties are skipped and not written to Firestore. If set to false
  /// or omitted, the SDK throws an exception when it encounters properties of type undefined.
  /// Web only.
  final bool ignoreUndefinedProperties;

  // https://github.com/firebase/firebase-js-sdk/issues/1674
  // https://github.com/firebase/flutterfire/issues/11149#issuecomment-1615133353
  final bool experimentalForceLongPolling;
  final bool experimentalAutoDetectLongPolling;

  /// Returns the settings as a [Map]
  Map<String, dynamic> get asMap {
    return {
      'persistenceEnabled': persistenceEnabled,
      'host': host,
      'sslEnabled': sslEnabled,
      'cacheSizeBytes': cacheSizeBytes,
      if (kIsWeb) 'ignoreUndefinedProperties': ignoreUndefinedProperties,
      if (kIsWeb) 'experimentalForceLongPolling': experimentalForceLongPolling,
      if (kIsWeb)
        'experimentalAutoDetectLongPolling': experimentalAutoDetectLongPolling,
    };
  }

  Settings copyWith({
    bool? persistenceEnabled,
    String? host,
    bool? sslEnabled,
    int? cacheSizeBytes,
    bool? ignoreUndefinedProperties,
    bool? experimentalForceLongPolling,
    bool? experimentalAutoDetectLongPolling,
  }) {
    assert(
        cacheSizeBytes == null ||
            cacheSizeBytes == CACHE_SIZE_UNLIMITED ||
            // 1mb and 100mb. minimum and maximum inclusive range.
            (cacheSizeBytes >= 1048576 && cacheSizeBytes <= 104857600),
        'Cache size must be between 1048576 bytes (inclusive) and 104857600 bytes (inclusive)');

    return Settings(
      persistenceEnabled: persistenceEnabled ?? this.persistenceEnabled,
      host: host ?? this.host,
      sslEnabled: sslEnabled ?? this.sslEnabled,
      cacheSizeBytes: cacheSizeBytes ?? this.cacheSizeBytes,
      ignoreUndefinedProperties:
          ignoreUndefinedProperties ?? this.ignoreUndefinedProperties,
      experimentalForceLongPolling:
          experimentalForceLongPolling ?? this.experimentalForceLongPolling,
      experimentalAutoDetectLongPolling: experimentalAutoDetectLongPolling ??
          this.experimentalAutoDetectLongPolling,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Settings &&
      other.runtimeType == runtimeType &&
      other.persistenceEnabled == persistenceEnabled &&
      other.host == host &&
      other.sslEnabled == sslEnabled &&
      other.cacheSizeBytes == cacheSizeBytes &&
      other.ignoreUndefinedProperties == ignoreUndefinedProperties &&
      other.experimentalForceLongPolling == experimentalForceLongPolling &&
      other.experimentalAutoDetectLongPolling ==
          experimentalAutoDetectLongPolling;

  @override
  int get hashCode => Object.hash(
        runtimeType,
        persistenceEnabled,
        host,
        sslEnabled,
        cacheSizeBytes,
        ignoreUndefinedProperties,
        experimentalForceLongPolling,
        experimentalAutoDetectLongPolling,
      );

  @override
  String toString() => 'Settings($asMap)';
}
