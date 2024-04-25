class Utils {
  static const List<String> urls = [
    'https://i.ytimg.com/vi/feEMKVcFyC4/sddefault.jpg',
    'https://c4.wallpaperflare.com/wallpaper/221/569/133/white-and-black-lighted-cruise-ships-at-night-wallpaper-preview.jpg',
    'https://c4.wallpaperflare.com/wallpaper/56/423/715/forest-street-wallpaper-preview.jpg',
    'https://hips.hearstapps.com/hmg-prod/images/neva-masquerade-royalty-free-image-1674509896.jpg'
  ];
  static final tags = {"all", "nature", "Cat"};
}

class PhotoState {
  late String url;
  bool selected;
  bool display;
  Set<String> tags = {};
  PhotoState(this.url, {this.selected = false, this.display = true, tags});
}
