# Media Library

Media management for images, audio, and video.

## Features

- Upload media files
- Organize by campaign
- Reference in content (scenes, entities, etc.)
- Multiple variants (original, thumbnails)
- Firebase Storage integration

## Data Model

```dart
@freezed
class MediaAsset with _$MediaAsset {
  const factory MediaAsset({
    required String id,
    required String filename,
    required String mime,
    required int size,
    @Default([]) List<Variant> variants,
    String? alt,
    @Default([]) List<String> captions,
  }) = _MediaAsset;
}
```

## Storage Structure

```
campaigns/{cid}/media/{assetId}/
  ├── original.ext
  ├── thumb.jpg
  └── medium.jpg
```

## Usage

Upload and reference:

```dart
// Upload
final asset = await mediaService.upload(file, campaignId);

// Reference in content
content.insertEmbed(index, 'image', {'assetId': asset.id});
```

## Related Documentation

- [Firebase Schema](../reference/firebase-schema.md)
- [Data Layer](../architecture/data-layer.md)
