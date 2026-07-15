///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:domain/goods.dart';
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
	@override late final _Translations$app$ja app = _Translations$app$ja._(_root);
	@override late final _Translations$error$ja error = _Translations$error$ja._(_root);
	@override late final _Translations$goods$ja goods = _Translations$goods$ja._(_root);
	@override late final _Translations$settings$ja settings = _Translations$settings$ja._(_root);
	@override late final _Translations$user$ja user = _Translations$user$ja._(_root);
}

// Path: app
class _Translations$app$ja extends Translations$app$en {
	_Translations$app$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$app$bottomNavBar$ja bottomNavBar = _Translations$app$bottomNavBar$ja._(_root);
	@override late final _Translations$app$homePage$ja homePage = _Translations$app$homePage$ja._(_root);
}

// Path: error
class _Translations$error$ja extends Translations$error$en {
	_Translations$error$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$error$errorPage$ja errorPage = _Translations$error$errorPage$ja._(_root);
	@override late final _Translations$error$message$ja message = _Translations$error$message$ja._(_root);
}

// Path: goods
class _Translations$goods$ja extends Translations$goods$en {
	_Translations$goods$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$goods$goodsPage$ja goodsPage = _Translations$goods$goodsPage$ja._(_root);
	@override String goodsSortKey({required GoodsSortKey context}) {
		switch (context) {
			case GoodsSortKey.createdAt:
				return '作成日時';
			case GoodsSortKey.name:
				return '商品名';
			case GoodsSortKey.price:
				return '価格';
		}
	}
}

// Path: settings
class _Translations$settings$ja extends Translations$settings$en {
	_Translations$settings$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$settings$settingsPage$ja settingsPage = _Translations$settings$settingsPage$ja._(_root);
	@override late final _Translations$settings$accountPage$ja accountPage = _Translations$settings$accountPage$ja._(_root);
}

// Path: user
class _Translations$user$ja extends Translations$user$en {
	_Translations$user$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$user$userPage$ja userPage = _Translations$user$userPage$ja._(_root);
	@override late final _Translations$user$onboardPage$ja onboardPage = _Translations$user$onboardPage$ja._(_root);
}

// Path: app.bottomNavBar
class _Translations$app$bottomNavBar$ja extends Translations$app$bottomNavBar$en {
	_Translations$app$bottomNavBar$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get home => 'ホーム';
	@override String get search => '探す';
	@override String get settings => '設定';
}

// Path: app.homePage
class _Translations$app$homePage$ja extends Translations$app$homePage$en {
	_Translations$app$homePage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'ホーム';
}

// Path: error.errorPage
class _Translations$error$errorPage$ja extends Translations$error$errorPage$en {
	_Translations$error$errorPage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'エラー';
}

// Path: error.message
class _Translations$error$message$ja extends Translations$error$message$en {
	_Translations$error$message$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override late final _Translations$error$message$impossibleOperation$ja impossibleOperation = _Translations$error$message$impossibleOperation$ja._(_root);
}

// Path: goods.goodsPage
class _Translations$goods$goodsPage$ja extends Translations$goods$goodsPage$en {
	_Translations$goods$goodsPage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '商品一覧';
	@override String get layout => '表示形式';
	@override String price({required num price}) => '${NumberFormat.simpleCurrency(locale: 'ja').format(price)}';
}

// Path: settings.settingsPage
class _Translations$settings$settingsPage$ja extends Translations$settings$settingsPage$en {
	_Translations$settings$settingsPage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '設定';
	@override late final _Translations$settings$settingsPage$account$ja account = _Translations$settings$settingsPage$account$ja._(_root);
	@override late final _Translations$settings$settingsPage$layout$ja layout = _Translations$settings$settingsPage$layout$ja._(_root);
	@override late final _Translations$settings$settingsPage$help$ja help = _Translations$settings$settingsPage$help$ja._(_root);
}

// Path: settings.accountPage
class _Translations$settings$accountPage$ja extends Translations$settings$accountPage$en {
	_Translations$settings$accountPage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'アカウント';
	@override late final _Translations$settings$accountPage$link$ja link = _Translations$settings$accountPage$link$ja._(_root);
	@override late final _Translations$settings$accountPage$other$ja other = _Translations$settings$accountPage$other$ja._(_root);
	@override late final _Translations$settings$accountPage$leaveConfirmDialog$ja leaveConfirmDialog = _Translations$settings$accountPage$leaveConfirmDialog$ja._(_root);
}

// Path: user.userPage
class _Translations$user$userPage$ja extends Translations$user$userPage$en {
	_Translations$user$userPage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => 'タイトル';
}

// Path: user.onboardPage
class _Translations$user$onboardPage$ja extends Translations$user$onboardPage$en {
	_Translations$user$onboardPage$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get start => 'はじめる';
	@override String get startCaption => 'はじめての方はこちら';
	@override String get signInWithGoogle => 'Googleアカウントでログイン';
	@override String get signInWithApple => 'Appleアカウントでログイン';
}

// Path: error.message.impossibleOperation
class _Translations$error$message$impossibleOperation$ja extends Translations$error$message$impossibleOperation$en {
	_Translations$error$message$impossibleOperation$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get notAuth => '認証済でないため操作が許可されていません';
	@override String get notLinked => 'アカウントが連携されていないため解除出来ません';
}

// Path: settings.settingsPage.account
class _Translations$settings$settingsPage$account$ja extends Translations$settings$settingsPage$account$en {
	_Translations$settings$settingsPage$account$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get head => 'アカウント';
	@override String get account => 'アカウント';
}

// Path: settings.settingsPage.layout
class _Translations$settings$settingsPage$layout$ja extends Translations$settings$settingsPage$layout$en {
	_Translations$settings$settingsPage$layout$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get haed => 'レイアウト';
	@override String get uiStyle => 'UIスタイル';
	@override String get themeMode => 'テーマモード';
	@override String get colorTheme => 'カラー';
}

// Path: settings.settingsPage.help
class _Translations$settings$settingsPage$help$ja extends Translations$settings$settingsPage$help$en {
	_Translations$settings$settingsPage$help$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get head => 'ヘルプ';
	@override String get howToUse => 'つかい方';
	@override String get contactUs => 'お問い合わせ';
	@override String get developperTwitter => '開発者情報';
	@override String get privacyPollicy => 'プライバシーポリシー';
	@override String get licencse => 'ライセンス';
}

// Path: settings.accountPage.link
class _Translations$settings$accountPage$link$ja extends Translations$settings$accountPage$link$en {
	_Translations$settings$accountPage$link$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get head => 'アカウント連携';
	@override String get google => 'Google';
	@override String get apple => 'Apple';
}

// Path: settings.accountPage.other
class _Translations$settings$accountPage$other$ja extends Translations$settings$accountPage$other$en {
	_Translations$settings$accountPage$other$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get head => 'その他';
	@override String get logout => 'ログアウト';
	@override String get leave => '退会';
}

// Path: settings.accountPage.leaveConfirmDialog
class _Translations$settings$accountPage$leaveConfirmDialog$ja extends Translations$settings$accountPage$leaveConfirmDialog$en {
	_Translations$settings$accountPage$leaveConfirmDialog$ja._(TranslationsJa root) : this._root = root, super.internal(root);

	final TranslationsJa _root; // ignore: unused_field

	// Translations
	@override String get title => '退会しますか？';
	@override String get body => '本当に退会してもよろしいですか？\nこの操作は元に戻すことができません。';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.bottomNavBar.home' => 'ホーム',
			'app.bottomNavBar.search' => '探す',
			'app.bottomNavBar.settings' => '設定',
			'app.homePage.title' => 'ホーム',
			'error.errorPage.title' => 'エラー',
			'error.message.impossibleOperation.notAuth' => '認証済でないため操作が許可されていません',
			'error.message.impossibleOperation.notLinked' => 'アカウントが連携されていないため解除出来ません',
			'goods.goodsPage.title' => '商品一覧',
			'goods.goodsPage.layout' => '表示形式',
			'goods.goodsPage.price' => ({required num price}) => '${NumberFormat.simpleCurrency(locale: 'ja').format(price)}',
			'goods.goodsSortKey' => ({required GoodsSortKey context}) { switch (context) { case GoodsSortKey.createdAt: return '作成日時'; case GoodsSortKey.name: return '商品名'; case GoodsSortKey.price: return '価格'; } }, 
			'settings.settingsPage.title' => '設定',
			'settings.settingsPage.account.head' => 'アカウント',
			'settings.settingsPage.account.account' => 'アカウント',
			'settings.settingsPage.layout.haed' => 'レイアウト',
			'settings.settingsPage.layout.uiStyle' => 'UIスタイル',
			'settings.settingsPage.layout.themeMode' => 'テーマモード',
			'settings.settingsPage.layout.colorTheme' => 'カラー',
			'settings.settingsPage.help.head' => 'ヘルプ',
			'settings.settingsPage.help.howToUse' => 'つかい方',
			'settings.settingsPage.help.contactUs' => 'お問い合わせ',
			'settings.settingsPage.help.developperTwitter' => '開発者情報',
			'settings.settingsPage.help.privacyPollicy' => 'プライバシーポリシー',
			'settings.settingsPage.help.licencse' => 'ライセンス',
			'settings.accountPage.title' => 'アカウント',
			'settings.accountPage.link.head' => 'アカウント連携',
			'settings.accountPage.link.google' => 'Google',
			'settings.accountPage.link.apple' => 'Apple',
			'settings.accountPage.other.head' => 'その他',
			'settings.accountPage.other.logout' => 'ログアウト',
			'settings.accountPage.other.leave' => '退会',
			'settings.accountPage.leaveConfirmDialog.title' => '退会しますか？',
			'settings.accountPage.leaveConfirmDialog.body' => '本当に退会してもよろしいですか？\nこの操作は元に戻すことができません。',
			'user.userPage.title' => 'タイトル',
			'user.onboardPage.start' => 'はじめる',
			'user.onboardPage.startCaption' => 'はじめての方はこちら',
			'user.onboardPage.signInWithGoogle' => 'Googleアカウントでログイン',
			'user.onboardPage.signInWithApple' => 'Appleアカウントでログイン',
			_ => null,
		};
	}
}
