import 'package:flutter/painting.dart';

import 'download_manager.dart';
import 'data.dart';

class AssetImage extends ImageProvider<FileImage> {
  AssetImage(this._asset, {this.scale = 1.0})
      : _fileImage = FileImage(_asset.downloadedFile, scale: scale);

  final AssetModel _asset;
  final double scale;
  final FileImage _fileImage;

  @override
  Future<FileImage> obtainKey(ImageConfiguration configuration) {
    if (DownloadManager.instance.cachedIsDownloaded(_asset.id)) {
      return _fileImage.obtainKey(configuration);
    } else {
      return (() async {
        await DownloadManager.instance.download(_asset).file;

        return _fileImage.obtainKey(configuration);
      })();
    }
  }

  @override
  ImageStreamCompleter loadImage(FileImage key, ImageDecoderCallback decode) {
    return key.loadImage(key, decode);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is AssetImage &&
        other._asset.id == _asset.id &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(_asset.id, scale);
}
