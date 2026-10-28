import 'package:riverpod/riverpod.dart';

/// 2 つの [AsyncValue] を 1 つの [AsyncValue] にまとめる。
/// どちらかが [AsyncLoading] なら loading、どちらかが値を持たないエラーならそのエラー、両方が値を持てば両方の値を組にした data を返す。
///
/// riverpod 2 系にしか対応していない async_value_group パッケージの `AsyncValueGroup.group2` と同じ結果を返す (#447)。
AsyncValue<(T1, T2)> groupAsyncValues2<T1, T2>({required AsyncValue<T1> first, required AsyncValue<T2> second}) {
  if (first is AsyncLoading || second is AsyncLoading) {
    return const AsyncLoading();
  }
  try {
    return AsyncData((first.requireValue, second.requireValue));
  } catch (error, stackTrace) {
    return AsyncError(error, stackTrace);
  }
}
