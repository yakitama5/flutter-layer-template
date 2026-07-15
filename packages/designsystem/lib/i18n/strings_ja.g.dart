///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:domain/core.dart';
import 'package:domain/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsJa extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsJa({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsJa _root = this; // ignore: unused_field

	@override 
	TranslationsJa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsJa(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$designsystem$ja designsystem = _Translations$designsystem$ja._(_root);
}

// Path: designsystem
class _Translations$designsystem$ja extends Translations$designsystem$en {
	_Translations$designsystem$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String uiStyle({required UIStyle context}) {
		switch (context) {
			case UIStyle.system:
				return 'システム設定';
			case UIStyle.android:
				return 'Android';
			case UIStyle.ios:
				return 'iOS';
		}
	}
	@override String themeColor({required ThemeColor context}) {
		switch (context) {
			case ThemeColor.dynamicColor:
				return 'ダイナミックカラー';
			case ThemeColor.appColor:
				return 'システムカラー';
			case ThemeColor.blue:
				return 'ブルー';
			case ThemeColor.purple:
				return 'パープル';
			case ThemeColor.green:
				return 'グリーン';
			case ThemeColor.red:
				return 'レッド';
			case ThemeColor.pink:
				return 'ピンク';
			case ThemeColor.yellow:
				return 'イエロー';
			case ThemeColor.orange:
				return 'オレンジ';
		}
	}
	@override String themeMode({required ThemeMode context}) {
		switch (context) {
			case ThemeMode.system:
				return 'システムテーマ';
			case ThemeMode.light:
				return 'ライトテーマ';
			case ThemeMode.dark:
				return 'ダークテーマ';
		}
	}
	@override late final _Translations$designsystem$viewLayout$ja viewLayout = _Translations$designsystem$viewLayout$ja._(_root);
	@override String sortOrder({required SortOrder context}) {
		switch (context) {
			case SortOrder.asc:
				return '昇順';
			case SortOrder.desc:
				return '降順';
		}
	}
	@override late final _Translations$designsystem$appUpdate$ja appUpdate = _Translations$designsystem$appUpdate$ja._(_root);
}

// Path: designsystem.viewLayout
class _Translations$designsystem$viewLayout$ja extends Translations$designsystem$viewLayout$en {
	_Translations$designsystem$viewLayout$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get name => '表示形式';
	@override String typeName({required ViewLayout context}) {
		switch (context) {
			case ViewLayout.grid:
				return 'グリッド表示';
			case ViewLayout.list:
				return 'リスト表示';
		}
	}
}

// Path: designsystem.appUpdate
class _Translations$designsystem$appUpdate$ja extends Translations$designsystem$appUpdate$en {
	_Translations$designsystem$appUpdate$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$designsystem$appUpdate$updatePossible$ja updatePossible = _Translations$designsystem$appUpdate$updatePossible$ja._(_root);
	@override late final _Translations$designsystem$appUpdate$forceUpdate$ja forceUpdate = _Translations$designsystem$appUpdate$forceUpdate$ja._(_root);
	@override String get navigateStore => 'ストアを開く';
}

// Path: designsystem.appUpdate.updatePossible
class _Translations$designsystem$appUpdate$updatePossible$ja extends Translations$designsystem$appUpdate$updatePossible$en {
	_Translations$designsystem$appUpdate$updatePossible$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get message => '新しいバージョンが公開されています。\nアップデートを行うと、新しい機能をご利用いただけます。\nアップデートを行いますか？';
}

// Path: designsystem.appUpdate.forceUpdate
class _Translations$designsystem$appUpdate$forceUpdate$ja extends Translations$designsystem$appUpdate$forceUpdate$en {
	_Translations$designsystem$appUpdate$forceUpdate$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get message => 'ご利用のバージョンは現在ご利用出来ません。\nストアから新しいバージョンをご利用下さい。';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'designsystem.uiStyle' => ({required UIStyle context}) { switch (context) { case UIStyle.system: return 'システム設定'; case UIStyle.android: return 'Android'; case UIStyle.ios: return 'iOS'; } }, 
			'designsystem.themeColor' => ({required ThemeColor context}) { switch (context) { case ThemeColor.dynamicColor: return 'ダイナミックカラー'; case ThemeColor.appColor: return 'システムカラー'; case ThemeColor.blue: return 'ブルー'; case ThemeColor.purple: return 'パープル'; case ThemeColor.green: return 'グリーン'; case ThemeColor.red: return 'レッド'; case ThemeColor.pink: return 'ピンク'; case ThemeColor.yellow: return 'イエロー'; case ThemeColor.orange: return 'オレンジ'; } }, 
			'designsystem.themeMode' => ({required ThemeMode context}) { switch (context) { case ThemeMode.system: return 'システムテーマ'; case ThemeMode.light: return 'ライトテーマ'; case ThemeMode.dark: return 'ダークテーマ'; } }, 
			'designsystem.viewLayout.name' => '表示形式',
			'designsystem.viewLayout.typeName' => ({required ViewLayout context}) { switch (context) { case ViewLayout.grid: return 'グリッド表示'; case ViewLayout.list: return 'リスト表示'; } }, 
			'designsystem.sortOrder' => ({required SortOrder context}) { switch (context) { case SortOrder.asc: return '昇順'; case SortOrder.desc: return '降順'; } }, 
			'designsystem.appUpdate.updatePossible.message' => '新しいバージョンが公開されています。\nアップデートを行うと、新しい機能をご利用いただけます。\nアップデートを行いますか？',
			'designsystem.appUpdate.forceUpdate.message' => 'ご利用のバージョンは現在ご利用出来ません。\nストアから新しいバージョンをご利用下さい。',
			'designsystem.appUpdate.navigateStore' => 'ストアを開く',
			_ => null,
		};
	}
}
