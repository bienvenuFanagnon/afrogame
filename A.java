name: afroevent
description: application pour les evenement

# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.8+8

environment:
  sdk: '>=3.0.0 <4.0.0'

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^3.6.0
  #  firebase_core: ^2.24.2
  #  firebase_auth: ^4.16.0
  firebase_auth: ^5.3.1
  #  cloud_firestore: ^4.14.0
  cloud_firestore: ^5.4.3
  #  firebase_storage: ^11.6.0
  firebase_storage: ^12.3.2
  firebase_dynamic_links: ^6.0.11
  animated_bottom_navigation_bar: ^1.3.3
  circular_reveal_animation: ^2.0.1
  auto_size_text: ^3.0.0
  flutter_vector_icons: ^2.0.0
  image_picker: ^1.1.2
  flutter_rating_bar: ^4.0.1
  carousel_slider: ^5.0.0
  get: ^4.6.6
  shared_preferences: ^2.3.4
  page_transition: ^2.1.0
  onesignal_flutter: ^5.2.9
  flutter_launcher_icons: ^0.14.2
  intl: ^0.20.1
  url_launcher: ^6.3.1
  flutter_video_thumbnail_plus: ^1.0.5
  cached_network_image: ^3.4.1
  video_player: ^2.9.3
  full_screen_image: ^2.0.0
  comment_tree: ^0.3.0
  hashtagable_v3: ^3.0.1
  fluttertagger: ^2.2.1



  #afrolook

  badges: ^3.1.2
  flutter_cache_manager: ^3.3.1
  collection: ^1.18.0
  numberpicker: ^2.1.2
  flutter_inner_drawer: ^1.0.0+1
#  phone_form_field: ^10.0.3
  flutter_svg: ^2.0.17
  #  ffmpeg_kit_flutter: ^4.5.1
  rxdart: ^0.27.2
  eva_icons_flutter: ^3.0.2
  image_watermark: ^0.1.0
  ionicons: ^0.1.2
  dio:
  equatable: ^2.0.3
  font_awesome_flutter: ^9.2.0

  anim_search_bar: ^2.0.3
  flutter_parsed_text: ^2.2.1
  grouped_list: ^5.1.2
  flutter_linkify: ^6.0.0
  csc_picker_plus: ^0.0.3
  country_flags: ^3.2.0
  country_code_picker: ^3.1.0
  palette_generator: ^0.3.3+6

  #  emoji_picker_flutter: ^1.6.0
  #  flutter_local_notifications: ^17.1.1
  http: any
  #  flutter_share: ^2.0.0
  share_plus: ^10.1.2
  html: ^0.15.1
  any_link_preview: ^3.0.0
  progress_indicators: ^1.0.0
  flutter_list_view: ^1.1.22
  pull_to_refresh: ^2.0.0
  audio_waveforms: ^1.0.1
  # For formatting time locale in message receipts
  timeago:
  #  native_video_view: ^1.0.5
  simple_tags: ^0.0.6
  dropdown_search: ^5.0.6
  stories_for_flutter: ^1.2.1
  provider: ^6.1.1
  loading_animation_widget: ^1.2.0+4


  flash: ^3.1.0
  pulp_flash: ^0.0.6
  searchable_listview: ^2.10.1
  popover_gtk: ^0.2.6+3
  deeplynks: ^1.0.7
  flick_video_player: ^0.9.0



  #  image: ^2.1.4

  image: ^4.3.0
  #  tflite: ^1.1.2
  camera: ^0.11.0+2
  #  tflite_flutter: ^0.11.0
  #  tflite_v2: ^1.0.0



  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
#  cupertino_icons: ^1.0.2
  #chatview: ^1.3.1
  intl_phone_field: ^3.2.0
#  flutter_vector_icons: ^2.0.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  ripple_wave: ^0.1.3
  skeletonizer: ^1.0.1
  flutter_chat_bubble: ^2.0.2
  chat_bubbles: ^1.6.0
  audioplayers: ^5.2.1
  flutter_carousel_widget: ^3.1.0

#  intl: ^0.19.0
  flutter_popup_menu_button: ^0.0.1+5
  popup_menu: ^2.0.0
  popup_menu_plus: ^0.0.6
  like_button: ^2.0.5
#  chewie: ^1.7.5
#  flutter_form_builder: ^9.2.1
  auto_animated: ^3.2.0
  #  flutter_animated_icons: ^1.0.1
  rate_in_stars: ^0.0.3
  flutter_card_swiper: ^7.0.0
  marquee: ^2.2.3
  flutter_email_sender: ^6.0.2
  random_color: ^1.0.5
  json_annotation: ^4.9.0

  #  video_thumbnail: ^0.5.3



  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  chewie: ^1.11.0

dev_dependencies:
  flutter_test:
    sdk: flutter


  build_runner: ^2.4.15
  json_serializable: ^6.9.5
  icons_launcher: ^3.0.1
  flutter_launcher_icons: "^0.14.3"



  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^5.0.0

icons_launcher:
  image_path: "assets/logo_sport_togo-rbg.png"
  platforms:
    android:
      enable: true
    ios:
      enable: true

#flutter_launcher_icons:
#  android: "launcher_icon"
#  ios: true
#  #  image_path: "assets/logo/afrolook_logo.png"
#  image_path: "assets/afrogame_logo.png"
#  min_sdk_android: 21 # android min sdk min:16, default 21
#  web:
#    generate: true
#    image_path: "assets/afrogame_logo.png"
#    background_color: "#hexcode"
#    theme_color: "#hexcode"
#  windows:
#    generate: true
#    #    image_path: "assets/logo/afrolook_logo.png"
#    image_path: "assets/afrogame_logo.png"
#flutter_icons:
#  android: true
#  ios: true
#  image_path: "assets/afrogame_logo.png"

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages
analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true