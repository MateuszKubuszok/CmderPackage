# Copyright (c) 2012 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

{
  'variables': {
    # A hook that can be overridden in other repositories to add additional
    # compilation targets to 'All'.
    'app_targets%': [],
    # For Android-specific targets.
    'android_app_targets%': [],
  },
  'targets': [
    {
      'target_name': 'All',
      'type': 'none',
      'xcode_create_dependents_test_runner': 1,
      'dependencies': [
        '<@(app_targets)',
        'some.gyp:*',
        '../base/base.gyp:*',
        '../testing/gmock.gyp:*',
        '../testing/gtest.gyp:*',
        '../third_party/icu/icu.gyp:*',
        '../third_party/libxml/libxml.gyp:*',
        '../third_party/zlib/zlib.gyp:*',
      ],
      'conditions': [
        ['OS=="win"', {
          'conditions': [
            ['win_use_allocator_shim==1', {
              'dependencies': [
                '../base/allocator/allocator.gyp:*',
              ],
            }],
          ],
        }, {
          'dependencies': [
            '../third_party/libevent/libevent.gyp:*',
          ],
        }],
      ],
    }, # target_name: All
  ],
  'conditions': [
    # TODO(GYP) - make gyp_all and gn_all work on iOS and Android also.
    ['OS!="ios" and OS!="android"', {
      'targets': [
        {
          'target_name': 'gn_all',
          'type': 'none',

          'dependencies': [
            '../base/base.gyp:base_unittests',
          ],
        },
      ],
    }], # OS!=ios
    ['OS=="android"', {
      'targets': [
        {
          # The current list of tests for android.  This is temporary
          # until the full set supported.  If adding a new test here,
          # please also add it to build/android/pylib/gtest/gtest_config.py,
          # else the test is not run.
          #
          # WARNING:
          # Do not add targets here without communicating the implications
          # on tryserver triggers and load.  Discuss with
          # chrome-infrastructure-team please.
          'target_name': 'android_builder_tests',
          'type': 'none',
          'dependencies': [
            '../base/android/jni_generator/jni_generator.gyp:jni_generator_tests',
            '../base/base.gyp:base_unittests',
            '../base/base.gyp:base_unittests_apk',
          ],
        },
      ], # targets
    }], # OS="android"
  ],  # conditions
}
