///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final i18n = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$error$en error = Translations$error$en.internal(_root);
	late final Translations$goods$en goods = Translations$goods$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$user$en user = Translations$user$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$app$bottomNavBar$en bottomNavBar = Translations$app$bottomNavBar$en.internal(_root);
	late final Translations$app$homePage$en homePage = Translations$app$homePage$en.internal(_root);
}

// Path: error
class Translations$error$en {
	Translations$error$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$error$errorPage$en errorPage = Translations$error$errorPage$en.internal(_root);
	late final Translations$error$message$en message = Translations$error$message$en.internal(_root);
}

// Path: goods
class Translations$goods$en {
	Translations$goods$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$goods$goodsPage$en goodsPage = Translations$goods$goodsPage$en.internal(_root);

	/// en: '(createdAt) {Created at} (name) {Name} (price) {Price}'
	String goodsSortKey({required GoodsSortKey context}) {
		switch (context) {
			case GoodsSortKey.createdAt:
				return 'Created at';
			case GoodsSortKey.name:
				return 'Name';
			case GoodsSortKey.price:
				return 'Price';
		}
	}
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$settings$settingsPage$en settingsPage = Translations$settings$settingsPage$en.internal(_root);
	late final Translations$settings$accountPage$en accountPage = Translations$settings$accountPage$en.internal(_root);
}

// Path: user
class Translations$user$en {
	Translations$user$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$user$userPage$en userPage = Translations$user$userPage$en.internal(_root);
	late final Translations$user$onboardPage$en onboardPage = Translations$user$onboardPage$en.internal(_root);
}

// Path: app.bottomNavBar
class Translations$app$bottomNavBar$en {
	Translations$app$bottomNavBar$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: app.homePage
class Translations$app$homePage$en {
	Translations$app$homePage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get title => 'Home';
}

// Path: error.errorPage
class Translations$error$errorPage$en {
	Translations$error$errorPage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Error'
	String get title => 'Error';
}

// Path: error.message
class Translations$error$message$en {
	Translations$error$message$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$error$message$impossibleOperation$en impossibleOperation = Translations$error$message$impossibleOperation$en.internal(_root);
}

// Path: goods.goodsPage
class Translations$goods$goodsPage$en {
	Translations$goods$goodsPage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Goods'
	String get title => 'Goods';

	/// en: 'Layout'
	String get layout => 'Layout';

	/// en: '${price: simpleCurrency}'
	String price({required num price}) => '${NumberFormat.simpleCurrency(locale: 'en').format(price)}';
}

// Path: settings.settingsPage
class Translations$settings$settingsPage$en {
	Translations$settings$settingsPage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	late final Translations$settings$settingsPage$account$en account = Translations$settings$settingsPage$account$en.internal(_root);
	late final Translations$settings$settingsPage$layout$en layout = Translations$settings$settingsPage$layout$en.internal(_root);
	late final Translations$settings$settingsPage$help$en help = Translations$settings$settingsPage$help$en.internal(_root);
}

// Path: settings.accountPage
class Translations$settings$accountPage$en {
	Translations$settings$accountPage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account'
	String get title => 'Account';

	late final Translations$settings$accountPage$link$en link = Translations$settings$accountPage$link$en.internal(_root);
	late final Translations$settings$accountPage$other$en other = Translations$settings$accountPage$other$en.internal(_root);
	late final Translations$settings$accountPage$leaveConfirmDialog$en leaveConfirmDialog = Translations$settings$accountPage$leaveConfirmDialog$en.internal(_root);
}

// Path: user.userPage
class Translations$user$userPage$en {
	Translations$user$userPage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Title'
	String get title => 'Title';
}

// Path: user.onboardPage
class Translations$user$onboardPage$en {
	Translations$user$onboardPage$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Start'
	String get start => 'Start';

	/// en: 'For first-time users, click here'
	String get startCaption => 'For first-time users, click here';

	/// en: 'Sign in with Google'
	String get signInWithGoogle => 'Sign in with Google';

	/// en: 'Sign in with Apple'
	String get signInWithApple => 'Sign in with Apple';
}

// Path: error.message.impossibleOperation
class Translations$error$message$impossibleOperation$en {
	Translations$error$message$impossibleOperation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Not auth'
	String get notAuth => 'Not auth';

	/// en: 'Not linked'
	String get notLinked => 'Not linked';
}

// Path: settings.settingsPage.account
class Translations$settings$settingsPage$account$en {
	Translations$settings$settingsPage$account$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account'
	String get head => 'Account';

	/// en: 'Account'
	String get account => 'Account';
}

// Path: settings.settingsPage.layout
class Translations$settings$settingsPage$layout$en {
	Translations$settings$settingsPage$layout$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Layout'
	String get head => 'Layout';

	/// en: 'UI Style'
	String get uiStyle => 'UI Style';

	/// en: 'ThemeMode'
	String get themeMode => 'ThemeMode';

	/// en: 'Colors'
	String get colorTheme => 'Colors';
}

// Path: settings.settingsPage.help
class Translations$settings$settingsPage$help$en {
	Translations$settings$settingsPage$help$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Help'
	String get head => 'Help';

	/// en: 'HowToUse'
	String get howToUse => 'HowToUse';

	/// en: 'Contact us'
	String get contactUs => 'Contact us';

	/// en: 'Developer'
	String get developerTwitter => 'Developer';

	/// en: 'Privacy Policy'
	String get privacyPolicy => 'Privacy Policy';

	/// en: 'License'
	String get license => 'License';
}

// Path: settings.accountPage.link
class Translations$settings$accountPage$link$en {
	Translations$settings$accountPage$link$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Account link'
	String get head => 'Account link';

	/// en: 'Google'
	String get google => 'Google';

	/// en: 'Apple'
	String get apple => 'Apple';
}

// Path: settings.accountPage.other
class Translations$settings$accountPage$other$en {
	Translations$settings$accountPage$other$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Other'
	String get head => 'Other';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Leave'
	String get leave => 'Leave';
}

// Path: settings.accountPage.leaveConfirmDialog
class Translations$settings$accountPage$leaveConfirmDialog$en {
	Translations$settings$accountPage$leaveConfirmDialog$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Leave?'
	String get title => 'Leave?';

	/// en: 'Are you sure you want to cancel your membership? \\Ўn this operation cannot be undone.'
	String get body => 'Are you sure you want to cancel your membership? \\Ўn this operation cannot be undone.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.bottomNavBar.home' => 'Home',
			'app.bottomNavBar.search' => 'Search',
			'app.bottomNavBar.settings' => 'Settings',
			'app.homePage.title' => 'Home',
			'error.errorPage.title' => 'Error',
			'error.message.impossibleOperation.notAuth' => 'Not auth',
			'error.message.impossibleOperation.notLinked' => 'Not linked',
			'goods.goodsPage.title' => 'Goods',
			'goods.goodsPage.layout' => 'Layout',
			'goods.goodsPage.price' => ({required num price}) => '${NumberFormat.simpleCurrency(locale: 'en').format(price)}',
			'goods.goodsSortKey' => ({required GoodsSortKey context}) { switch (context) { case GoodsSortKey.createdAt: return 'Created at'; case GoodsSortKey.name: return 'Name'; case GoodsSortKey.price: return 'Price'; } }, 
			'settings.settingsPage.title' => 'Settings',
			'settings.settingsPage.account.head' => 'Account',
			'settings.settingsPage.account.account' => 'Account',
			'settings.settingsPage.layout.head' => 'Layout',
			'settings.settingsPage.layout.uiStyle' => 'UI Style',
			'settings.settingsPage.layout.themeMode' => 'ThemeMode',
			'settings.settingsPage.layout.colorTheme' => 'Colors',
			'settings.settingsPage.help.head' => 'Help',
			'settings.settingsPage.help.howToUse' => 'HowToUse',
			'settings.settingsPage.help.contactUs' => 'Contact us',
			'settings.settingsPage.help.developerTwitter' => 'Developer',
			'settings.settingsPage.help.privacyPolicy' => 'Privacy Policy',
			'settings.settingsPage.help.license' => 'License',
			'settings.accountPage.title' => 'Account',
			'settings.accountPage.link.head' => 'Account link',
			'settings.accountPage.link.google' => 'Google',
			'settings.accountPage.link.apple' => 'Apple',
			'settings.accountPage.other.head' => 'Other',
			'settings.accountPage.other.logout' => 'Logout',
			'settings.accountPage.other.leave' => 'Leave',
			'settings.accountPage.leaveConfirmDialog.title' => 'Leave?',
			'settings.accountPage.leaveConfirmDialog.body' => 'Are you sure you want to cancel your membership? \\Ўn this operation cannot be undone.',
			'user.userPage.title' => 'Title',
			'user.onboardPage.start' => 'Start',
			'user.onboardPage.startCaption' => 'For first-time users, click here',
			'user.onboardPage.signInWithGoogle' => 'Sign in with Google',
			'user.onboardPage.signInWithApple' => 'Sign in with Apple',
			_ => null,
		};
	}
}
