import '../../core/models.dart';

/// Why a shared MindDeck payload could not be accepted.
enum MindDeckSnapshotErrorCode {
  malformedEnvelope,
  unsupportedVersion,
  payloadTooLarge,
  invalidPayload,
  corruptPayload,
  nonCanonicalPayload,
}

/// A safe, user-presentable failure raised while decoding shared content.
class MindDeckSnapshotException implements Exception {
  const MindDeckSnapshotException(this.code, this.message);

  final MindDeckSnapshotErrorCode code;
  final String message;

  @override
  String toString() => 'MindDeckSnapshotException($code): $message';
}

/// Content identity and provenance that can be stored beside an imported deck.
///
/// The digest identifies the exact canonical snapshot. It deliberately does
/// not contain learning progress or any device-specific data.
class SnapshotMetadata {
  const SnapshotMetadata({
    required this.schemaVersion,
    required this.digest,
    required this.sourceDeckId,
    required this.cardCount,
    required this.decodedByteCount,
  });

  final int schemaVersion;
  final String digest;
  final String sourceDeckId;
  final int cardCount;
  final int decodedByteCount;
}

/// A fully validated snapshot that is safe to show in an import preview.
class DecodedMindDeckSnapshot {
  const DecodedMindDeckSnapshot({required this.deck, required this.metadata});

  final Deck deck;
  final SnapshotMetadata metadata;
}

/// Metadata retained after an independent deck copy is imported.
class ImportedSnapshotMetadata {
  const ImportedSnapshotMetadata({
    required this.digest,
    required this.sourceDeckId,
    required this.schemaVersion,
  });

  factory ImportedSnapshotMetadata.fromSnapshot(SnapshotMetadata metadata) {
    return ImportedSnapshotMetadata(
      digest: metadata.digest,
      sourceDeckId: metadata.sourceDeckId,
      schemaVersion: metadata.schemaVersion,
    );
  }

  final String digest;
  final String sourceDeckId;
  final int schemaVersion;
}

/// Describes an already-imported byte-for-byte equivalent snapshot.
class ExactDuplicateMatch {
  const ExactDuplicateMatch({
    required this.existingDeckId,
    required this.metadata,
  });

  final String existingDeckId;
  final ImportedSnapshotMetadata metadata;
}

/// An independent local deck plus the provenance to persist with it.
class MindDeckImportCandidate {
  const MindDeckImportCandidate({required this.deck, required this.source});

  final Deck deck;
  final ImportedSnapshotMetadata source;
}

enum MindDeckShareKind { link, file }

/// A prepared share that can be inspected before opening a platform dialog.
class MindDeckSharePayload {
  const MindDeckSharePayload._({
    required this.kind,
    required this.metadata,
    this.link,
    this.fileBytes,
    this.fileName,
  });

  const MindDeckSharePayload.link({
    required Uri link,
    required SnapshotMetadata metadata,
  }) : this._(kind: MindDeckShareKind.link, link: link, metadata: metadata);

  const MindDeckSharePayload.file({
    required List<int> fileBytes,
    required String fileName,
    required SnapshotMetadata metadata,
  }) : this._(
         kind: MindDeckShareKind.file,
         fileBytes: fileBytes,
         fileName: fileName,
         metadata: metadata,
       );

  final MindDeckShareKind kind;
  final Uri? link;
  final List<int>? fileBytes;
  final String? fileName;
  final SnapshotMetadata metadata;
}
