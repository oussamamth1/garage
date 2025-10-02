import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @contryCode.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get contryCode;

  /// No description provided for @weSentCodeTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to'**
  String get weSentCodeTo;

  /// No description provided for @enterPhoneNumberToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get enterPhoneNumberToContinue;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @verifyOTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOTP;

  /// No description provided for @phoneAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Phone Authentication'**
  String get phoneAuthentication;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @phoneMustStartWithCountryCode.
  ///
  /// In en, this message translates to:
  /// **'Phone must start with country code (e.g., +974)'**
  String get phoneMustStartWithCountryCode;

  /// No description provided for @pleaseEnterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get pleaseEnterValidPhoneNumber;

  /// No description provided for @reservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get reservations;

  /// No description provided for @excursion.
  ///
  /// In en, this message translates to:
  /// **'Excursion'**
  String get excursion;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @fastMoto.
  ///
  /// In en, this message translates to:
  /// **'Fast Moto'**
  String get fastMoto;

  /// No description provided for @eagles.
  ///
  /// In en, this message translates to:
  /// **'Eagles'**
  String get eagles;

  /// No description provided for @equipEaglesForFastMoto.
  ///
  /// In en, this message translates to:
  /// **'Team Eagles for Fast Moto'**
  String get equipEaglesForFastMoto;

  /// No description provided for @select_date.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get select_date;

  /// No description provided for @select_dates.
  ///
  /// In en, this message translates to:
  /// **'Select dates'**
  String get select_dates;

  /// No description provided for @displayActivityZones.
  ///
  /// In en, this message translates to:
  /// **'Display activity zones'**
  String get displayActivityZones;

  /// No description provided for @displayCategories.
  ///
  /// In en, this message translates to:
  /// **'Display categories'**
  String get displayCategories;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get letsGetStarted;

  /// No description provided for @conversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get conversation;

  /// No description provided for @chooseAction.
  ///
  /// In en, this message translates to:
  /// **'Choose an action'**
  String get chooseAction;

  /// No description provided for @noActivities.
  ///
  /// In en, this message translates to:
  /// **'No activities for you'**
  String get noActivities;

  /// No description provided for @checkYourRegion.
  ///
  /// In en, this message translates to:
  /// **'Check your region'**
  String get checkYourRegion;

  /// No description provided for @pleaseConnectToInternet.
  ///
  /// In en, this message translates to:
  /// **'Please connect to the internet'**
  String get pleaseConnectToInternet;

  /// No description provided for @categoriesAnimation.
  ///
  /// In en, this message translates to:
  /// **'Categories Animation'**
  String get categoriesAnimation;

  /// No description provided for @subscribeToTransfer.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to transfer'**
  String get subscribeToTransfer;

  /// No description provided for @subscribedToTransfer.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to transfer'**
  String get subscribedToTransfer;

  /// No description provided for @unsubscribedFromTransfer.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribed from transfer'**
  String get unsubscribedFromTransfer;

  /// No description provided for @subscribedToTask.
  ///
  /// In en, this message translates to:
  /// **'Subscribed to task'**
  String get subscribedToTask;

  /// No description provided for @unsubscribedFromTask.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribed from task'**
  String get unsubscribedFromTask;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @common.
  ///
  /// In en, this message translates to:
  /// **'Common'**
  String get common;

  /// No description provided for @customYourActivityColor.
  ///
  /// In en, this message translates to:
  /// **'Customize your activity color'**
  String get customYourActivityColor;

  /// No description provided for @selectCustomColor.
  ///
  /// In en, this message translates to:
  /// **'Select custom color'**
  String get selectCustomColor;

  /// No description provided for @customYourTransferColor.
  ///
  /// In en, this message translates to:
  /// **'Customize your transfer color'**
  String get customYourTransferColor;

  /// No description provided for @accueil.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get accueil;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Tourist guide'**
  String get guide;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @recherche.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get recherche;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @trierPar.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get trierPar;

  /// No description provided for @prixCroissant.
  ///
  /// In en, this message translates to:
  /// **'Price (ascending)'**
  String get prixCroissant;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @pays.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get pays;

  /// No description provided for @nomAZ.
  ///
  /// In en, this message translates to:
  /// **'Name (A-Z)'**
  String get nomAZ;

  /// No description provided for @sunshine.
  ///
  /// In en, this message translates to:
  /// **'SunShine'**
  String get sunshine;

  /// No description provided for @bienvenue.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get bienvenue;

  /// No description provided for @yourGroup.
  ///
  /// In en, this message translates to:
  /// **'Your Group'**
  String get yourGroup;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @pick_your_language.
  ///
  /// In en, this message translates to:
  /// **'Pick your language'**
  String get pick_your_language;

  /// No description provided for @hideEmptyScheduleWeek.
  ///
  /// In en, this message translates to:
  /// **'Hide Empty Schedule Week'**
  String get hideEmptyScheduleWeek;

  /// No description provided for @chooseYourBackgroundCover.
  ///
  /// In en, this message translates to:
  /// **'Choose your background cover'**
  String get chooseYourBackgroundCover;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @mes_groupes.
  ///
  /// In en, this message translates to:
  /// **'My Groups'**
  String get mes_groupes;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @calendrier.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendrier;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @themesAndCustomColor.
  ///
  /// In en, this message translates to:
  /// **'themes And CustomColor'**
  String get themesAndCustomColor;

  /// No description provided for @enableCustomTheme.
  ///
  /// In en, this message translates to:
  /// **'enable Custom Theme'**
  String get enableCustomTheme;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @diary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diary;

  /// No description provided for @eaten.
  ///
  /// In en, this message translates to:
  /// **'eaten'**
  String get eaten;

  /// No description provided for @log_your_weight.
  ///
  /// In en, this message translates to:
  /// **'Log your weight'**
  String get log_your_weight;

  /// No description provided for @current_Goal.
  ///
  /// In en, this message translates to:
  /// **'Current Goal'**
  String get current_Goal;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @water_balance.
  ///
  /// In en, this message translates to:
  /// **'Water balance'**
  String get water_balance;

  /// No description provided for @water_intake.
  ///
  /// In en, this message translates to:
  /// **'Water intake'**
  String get water_intake;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @meal_Plan.
  ///
  /// In en, this message translates to:
  /// **'Meal Plan'**
  String get meal_Plan;

  /// No description provided for @meal_preparing.
  ///
  /// In en, this message translates to:
  /// **'Your meal plan is being prepared! Please wait a few more moments'**
  String get meal_preparing;

  /// No description provided for @no_meal_plan_for.
  ///
  /// In en, this message translates to:
  /// **'No meal plan for'**
  String get no_meal_plan_for;

  /// No description provided for @snack1.
  ///
  /// In en, this message translates to:
  /// **'1st Snack'**
  String get snack1;

  /// No description provided for @snack2.
  ///
  /// In en, this message translates to:
  /// **'2nd Snack'**
  String get snack2;

  /// No description provided for @swap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forgetPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @track.
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @people_with_notifications.
  ///
  /// In en, this message translates to:
  /// **'People with notifications turned on report getting 62% better result'**
  String get people_with_notifications;

  /// No description provided for @we_will_send_useful.
  ///
  /// In en, this message translates to:
  /// **'We will send useful tips and regular reminders to increase your success'**
  String get we_will_send_useful;

  /// No description provided for @set_up_notifications.
  ///
  /// In en, this message translates to:
  /// **'Set up notifications'**
  String get set_up_notifications;

  /// No description provided for @remind_me_later.
  ///
  /// In en, this message translates to:
  /// **'Remind me later'**
  String get remind_me_later;

  /// No description provided for @search_Recipes.
  ///
  /// In en, this message translates to:
  /// **'Search Recipes..'**
  String get search_Recipes;

  /// No description provided for @most_Recent_Searches_by_People.
  ///
  /// In en, this message translates to:
  /// **'Most Recent Searches by People'**
  String get most_Recent_Searches_by_People;

  /// No description provided for @baking.
  ///
  /// In en, this message translates to:
  /// **'Baking'**
  String get baking;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @sauces.
  ///
  /// In en, this message translates to:
  /// **'Sauces'**
  String get sauces;

  /// No description provided for @meat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get meat;

  /// No description provided for @turkey.
  ///
  /// In en, this message translates to:
  /// **'Turkey'**
  String get turkey;

  /// No description provided for @chicken.
  ///
  /// In en, this message translates to:
  /// **'Chicken'**
  String get chicken;

  /// No description provided for @sausages.
  ///
  /// In en, this message translates to:
  /// **'Sausages'**
  String get sausages;

  /// No description provided for @mince.
  ///
  /// In en, this message translates to:
  /// **'Mince'**
  String get mince;

  /// No description provided for @burgers.
  ///
  /// In en, this message translates to:
  /// **'Burgers'**
  String get burgers;

  /// No description provided for @pasta.
  ///
  /// In en, this message translates to:
  /// **'Pasta'**
  String get pasta;

  /// No description provided for @noodles.
  ///
  /// In en, this message translates to:
  /// **'Noodles'**
  String get noodles;

  /// No description provided for @pizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get pizza;

  /// No description provided for @soups.
  ///
  /// In en, this message translates to:
  /// **'Soups'**
  String get soups;

  /// No description provided for @recipes_by_categories.
  ///
  /// In en, this message translates to:
  /// **'Recipes by categories'**
  String get recipes_by_categories;

  /// No description provided for @main_course.
  ///
  /// In en, this message translates to:
  /// **'main course'**
  String get main_course;

  /// No description provided for @side_dish.
  ///
  /// In en, this message translates to:
  /// **'side dish'**
  String get side_dish;

  /// No description provided for @dessert.
  ///
  /// In en, this message translates to:
  /// **'dessert'**
  String get dessert;

  /// No description provided for @appetizer.
  ///
  /// In en, this message translates to:
  /// **'appetizer'**
  String get appetizer;

  /// No description provided for @salad.
  ///
  /// In en, this message translates to:
  /// **'salad'**
  String get salad;

  /// No description provided for @bread.
  ///
  /// In en, this message translates to:
  /// **'bread'**
  String get bread;

  /// No description provided for @soup.
  ///
  /// In en, this message translates to:
  /// **'soup'**
  String get soup;

  /// No description provided for @beverage.
  ///
  /// In en, this message translates to:
  /// **'beverage'**
  String get beverage;

  /// No description provided for @sauce.
  ///
  /// In en, this message translates to:
  /// **'sauce'**
  String get sauce;

  /// No description provided for @marinade.
  ///
  /// In en, this message translates to:
  /// **'marinade'**
  String get marinade;

  /// No description provided for @fingerfood.
  ///
  /// In en, this message translates to:
  /// **'fingerfood'**
  String get fingerfood;

  /// No description provided for @drink.
  ///
  /// In en, this message translates to:
  /// **'drink'**
  String get drink;

  /// No description provided for @you_dont_have_any_Favorite_recipe_yet.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any Favorite recipe yet.'**
  String get you_dont_have_any_Favorite_recipe_yet;

  /// No description provided for @severe_Thinness.
  ///
  /// In en, this message translates to:
  /// **'Severe Thinness'**
  String get severe_Thinness;

  /// No description provided for @moderate_Thinness.
  ///
  /// In en, this message translates to:
  /// **'Moderate Thinness'**
  String get moderate_Thinness;

  /// No description provided for @mild_Thinness.
  ///
  /// In en, this message translates to:
  /// **'Mild Thinness'**
  String get mild_Thinness;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @overweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get overweight;

  /// No description provided for @obese_Class_I.
  ///
  /// In en, this message translates to:
  /// **'Obese Class I'**
  String get obese_Class_I;

  /// No description provided for @obese_Class_II.
  ///
  /// In en, this message translates to:
  /// **'Obese Class II'**
  String get obese_Class_II;

  /// No description provided for @obese_Class_III.
  ///
  /// In en, this message translates to:
  /// **'Obese Class III'**
  String get obese_Class_III;

  /// No description provided for @current_BMI.
  ///
  /// In en, this message translates to:
  /// **'Current BMI'**
  String get current_BMI;

  /// No description provided for @your_weight_is.
  ///
  /// In en, this message translates to:
  /// **'Your weight is'**
  String get your_weight_is;

  /// No description provided for @underweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get underweight;

  /// No description provided for @obese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get obese;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @personal_details.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get personal_details;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get log_out;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @starting_weight.
  ///
  /// In en, this message translates to:
  /// **'Starting weight'**
  String get starting_weight;

  /// No description provided for @target_weight.
  ///
  /// In en, this message translates to:
  /// **'Target weight'**
  String get target_weight;

  /// No description provided for @current_weight.
  ///
  /// In en, this message translates to:
  /// **'Current weight'**
  String get current_weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @restrictions.
  ///
  /// In en, this message translates to:
  /// **'Restrictions'**
  String get restrictions;

  /// No description provided for @no_meats_products.
  ///
  /// In en, this message translates to:
  /// **'No meats products'**
  String get no_meats_products;

  /// No description provided for @no_dairys_products.
  ///
  /// In en, this message translates to:
  /// **'No dairys products'**
  String get no_dairys_products;

  /// No description provided for @no_cereals_products.
  ///
  /// In en, this message translates to:
  /// **'No cereals products'**
  String get no_cereals_products;

  /// No description provided for @no_fruits_products.
  ///
  /// In en, this message translates to:
  /// **'No fruits products'**
  String get no_fruits_products;

  /// No description provided for @no_vegetables_products.
  ///
  /// In en, this message translates to:
  /// **'No vegetables products'**
  String get no_vegetables_products;

  /// No description provided for @meals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get meals;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @recommended_mealtime.
  ///
  /// In en, this message translates to:
  /// **'Recommended mealtime based on 16/8 intermittent fasting scheme'**
  String get recommended_mealtime;

  /// No description provided for @first_snack.
  ///
  /// In en, this message translates to:
  /// **'First Snack'**
  String get first_snack;

  /// No description provided for @second_snack.
  ///
  /// In en, this message translates to:
  /// **'Second Snack'**
  String get second_snack;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @delete_my_account.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get delete_my_account;

  /// No description provided for @language_setup.
  ///
  /// In en, this message translates to:
  /// **'Language setup'**
  String get language_setup;

  /// No description provided for @you_can_change_language_later.
  ///
  /// In en, this message translates to:
  /// **'You can change language in Settings later'**
  String get you_can_change_language_later;

  /// No description provided for @imperial.
  ///
  /// In en, this message translates to:
  /// **'Imperial'**
  String get imperial;

  /// No description provided for @meals_per_day.
  ///
  /// In en, this message translates to:
  /// **'Meals per day'**
  String get meals_per_day;

  /// No description provided for @times.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// No description provided for @two_times.
  ///
  /// In en, this message translates to:
  /// **'Two times'**
  String get two_times;

  /// No description provided for @breakfast_dinner_2_snacks.
  ///
  /// In en, this message translates to:
  /// **'Breakfast, dinner and 2 snacks'**
  String get breakfast_dinner_2_snacks;

  /// No description provided for @three_times.
  ///
  /// In en, this message translates to:
  /// **'Three times'**
  String get three_times;

  /// No description provided for @breakfast_lunch_dinner.
  ///
  /// In en, this message translates to:
  /// **'Breakfast, lunch and dinner'**
  String get breakfast_lunch_dinner;

  /// No description provided for @four_times.
  ///
  /// In en, this message translates to:
  /// **'Four times'**
  String get four_times;

  /// No description provided for @breakfast_snack_lunch_dinner.
  ///
  /// In en, this message translates to:
  /// **'Breakfast, snack lunch and dinner'**
  String get breakfast_snack_lunch_dinner;

  /// No description provided for @five_times.
  ///
  /// In en, this message translates to:
  /// **'Five times'**
  String get five_times;

  /// No description provided for @breakfast_lunch_dinner_2_snacks.
  ///
  /// In en, this message translates to:
  /// **'Breakfast, lunch, dinner and 2 snacks'**
  String get breakfast_lunch_dinner_2_snacks;

  /// No description provided for @verification_email_has_been_sent.
  ///
  /// In en, this message translates to:
  /// **'A verification email has been sent to your email address. Please validate it to continue sign in'**
  String get verification_email_has_been_sent;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @your_email.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get your_email;

  /// No description provided for @email_address_required.
  ///
  /// In en, this message translates to:
  /// **'Email address is a required field'**
  String get email_address_required;

  /// No description provided for @please_use_valid_email_address.
  ///
  /// In en, this message translates to:
  /// **'Please use a valid email address'**
  String get please_use_valid_email_address;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is a required field'**
  String get password_required;

  /// No description provided for @your_Password.
  ///
  /// In en, this message translates to:
  /// **'Your Password'**
  String get your_Password;

  /// No description provided for @you_agree_to_our_terms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our terms of use and privacy policy'**
  String get you_agree_to_our_terms;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get sign_up;

  /// No description provided for @you_have_any_issues.
  ///
  /// In en, this message translates to:
  /// **'In case you have any issues, please contact us via email support@fitfood.com or visit FAQ'**
  String get you_have_any_issues;

  /// No description provided for @check_with_your_doctor.
  ///
  /// In en, this message translates to:
  /// **'Check with your doctor in addition to using the app and before making medical decisions'**
  String get check_with_your_doctor;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @what_is_your_Goal.
  ///
  /// In en, this message translates to:
  /// **'What is your Goal?'**
  String get what_is_your_Goal;

  /// No description provided for @to_continue_please_accept_our_terms.
  ///
  /// In en, this message translates to:
  /// **'To continue please accept our terms and policies bellow'**
  String get to_continue_please_accept_our_terms;

  /// No description provided for @gain_Weight.
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get gain_Weight;

  /// No description provided for @lose_Weight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get lose_Weight;

  /// No description provided for @maintain_Weight.
  ///
  /// In en, this message translates to:
  /// **'Maintain Weight'**
  String get maintain_Weight;

  /// No description provided for @by_continuing_I_agree.
  ///
  /// In en, this message translates to:
  /// **'By continuing, I agree with Terms of Service, Privacy Policy, Money-Back Policy, Subscription terms, Cookie policy'**
  String get by_continuing_I_agree;

  /// No description provided for @i_would_like_to_receive_updates.
  ///
  /// In en, this message translates to:
  /// **'I would like to receive updates about products, services, and special offers from Fit\'food via email'**
  String get i_would_like_to_receive_updates;

  /// No description provided for @we_recommend_to_consult_your_physician.
  ///
  /// In en, this message translates to:
  /// **'We recommend you to consult your physician before starting to follow any weight loss program'**
  String get we_recommend_to_consult_your_physician;

  /// No description provided for @previous_Step.
  ///
  /// In en, this message translates to:
  /// **'Previous Step'**
  String get previous_Step;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @select_your_gender.
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get select_your_gender;

  /// No description provided for @man.
  ///
  /// In en, this message translates to:
  /// **'Man'**
  String get man;

  /// No description provided for @woman.
  ///
  /// In en, this message translates to:
  /// **'Woman'**
  String get woman;

  /// No description provided for @lactation.
  ///
  /// In en, this message translates to:
  /// **'Lactation'**
  String get lactation;

  /// No description provided for @pregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get pregnancy;

  /// No description provided for @select_your_kitchen.
  ///
  /// In en, this message translates to:
  /// **'Select your kitchen'**
  String get select_your_kitchen;

  /// No description provided for @what_is_your_desired_weight.
  ///
  /// In en, this message translates to:
  /// **'Ok, what is your desired weight?'**
  String get what_is_your_desired_weight;

  /// No description provided for @desired_weight.
  ///
  /// In en, this message translates to:
  /// **'Desired weight'**
  String get desired_weight;

  /// No description provided for @desired_Weight_required.
  ///
  /// In en, this message translates to:
  /// **'Desired Weight is a required field'**
  String get desired_Weight_required;

  /// No description provided for @check_you_body_measures.
  ///
  /// In en, this message translates to:
  /// **'Let\'s check you body measures'**
  String get check_you_body_measures;

  /// No description provided for @age_years.
  ///
  /// In en, this message translates to:
  /// **'Age (years)'**
  String get age_years;

  /// No description provided for @age_required.
  ///
  /// In en, this message translates to:
  /// **'Age is a required field'**
  String get age_required;

  /// No description provided for @height_unit.
  ///
  /// In en, this message translates to:
  /// **'Height ({unit})'**
  String height_unit(String unit);

  /// No description provided for @height_unit_required.
  ///
  /// In en, this message translates to:
  /// **'Height ({unit}) is a required field'**
  String height_unit_required(String unit);

  /// No description provided for @current_weight_required.
  ///
  /// In en, this message translates to:
  /// **'Current Weight is a required field'**
  String get current_weight_required;

  /// No description provided for @body_type.
  ///
  /// In en, this message translates to:
  /// **'What is your body type?'**
  String get body_type;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'application'**
  String get application;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get setting;

  /// No description provided for @langAR.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langAR;

  /// No description provided for @langEN.
  ///
  /// In en, this message translates to:
  /// **'Anglais'**
  String get langEN;

  /// No description provided for @langFr.
  ///
  /// In en, this message translates to:
  /// **'Frannce'**
  String get langFr;

  /// No description provided for @langDe.
  ///
  /// In en, this message translates to:
  /// **'Allemagne'**
  String get langDe;

  /// No description provided for @langEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get langEs;

  /// No description provided for @langPt.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get langPt;

  /// No description provided for @langRu.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get langRu;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'blue'**
  String get blue;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'green'**
  String get green;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'purple'**
  String get purple;

  /// No description provided for @each_body_type_specific_metabolic_structure.
  ///
  /// In en, this message translates to:
  /// **'Each body type has a specific metabolic structure'**
  String get each_body_type_specific_metabolic_structure;

  /// No description provided for @pear_shaped.
  ///
  /// In en, this message translates to:
  /// **'Pear-shaped'**
  String get pear_shaped;

  /// No description provided for @naturally_slimmer_shoulders.
  ///
  /// In en, this message translates to:
  /// **'Naturally slimmer shoulders and thicker thighs'**
  String get naturally_slimmer_shoulders;

  /// No description provided for @ectomorph.
  ///
  /// In en, this message translates to:
  /// **'Ectomorph'**
  String get ectomorph;

  /// No description provided for @lean_long_fast_metabolism.
  ///
  /// In en, this message translates to:
  /// **'Lean and long, fast metabolism'**
  String get lean_long_fast_metabolism;

  /// No description provided for @square_shaped.
  ///
  /// In en, this message translates to:
  /// **'Square-shaped'**
  String get square_shaped;

  /// No description provided for @naturally_wide_shoulders_thighs.
  ///
  /// In en, this message translates to:
  /// **'Naturally wide shoulders and thighs'**
  String get naturally_wide_shoulders_thighs;

  /// No description provided for @mesomorph.
  ///
  /// In en, this message translates to:
  /// **'Mesomorph'**
  String get mesomorph;

  /// No description provided for @muscular_average_metabolism.
  ///
  /// In en, this message translates to:
  /// **'Muscular and well-built, average metabolism'**
  String get muscular_average_metabolism;

  /// No description provided for @hourglass.
  ///
  /// In en, this message translates to:
  /// **'Hourglass'**
  String get hourglass;

  /// No description provided for @wide_bust_hips.
  ///
  /// In en, this message translates to:
  /// **'Wide bust and hips, a narrow waist'**
  String get wide_bust_hips;

  /// No description provided for @endomorph.
  ///
  /// In en, this message translates to:
  /// **'Endomorph'**
  String get endomorph;

  /// No description provided for @soft_round_slow_metabolism.
  ///
  /// In en, this message translates to:
  /// **'Soft and round, slow metabolism'**
  String get soft_round_slow_metabolism;

  /// No description provided for @apple_shaped.
  ///
  /// In en, this message translates to:
  /// **'Apple-shaped'**
  String get apple_shaped;

  /// No description provided for @naturally_wide_torso_broad_shoulders.
  ///
  /// In en, this message translates to:
  /// **'Naturally wide torso and broad shoulders'**
  String get naturally_wide_torso_broad_shoulders;

  /// No description provided for @describe_your_typical_day.
  ///
  /// In en, this message translates to:
  /// **'Describe your typical day'**
  String get describe_your_typical_day;

  /// No description provided for @who_want_to_require.
  ///
  /// In en, this message translates to:
  /// **'{gender} who want to {objective}, require a more personalized approach depending on the current lifestyle.'**
  String who_want_to_require(String gender, String objective);

  /// No description provided for @at_the_office.
  ///
  /// In en, this message translates to:
  /// **'At the office'**
  String get at_the_office;

  /// No description provided for @daily_long_walks.
  ///
  /// In en, this message translates to:
  /// **'Daily long walks'**
  String get daily_long_walks;

  /// No description provided for @physical_work.
  ///
  /// In en, this message translates to:
  /// **'Physical work'**
  String get physical_work;

  /// No description provided for @mostly_at_home.
  ///
  /// In en, this message translates to:
  /// **'Mostly at home'**
  String get mostly_at_home;

  /// No description provided for @how_many_times_you_want_to_eat.
  ///
  /// In en, this message translates to:
  /// **'How many times a day do you want to eat?'**
  String get how_many_times_you_want_to_eat;

  /// No description provided for @will_plan_your_meals_according_preferences.
  ///
  /// In en, this message translates to:
  /// **'We will plan your meals according to your preferences'**
  String get will_plan_your_meals_according_preferences;

  /// No description provided for @works_at_the_office.
  ///
  /// In en, this message translates to:
  /// **'works at the office'**
  String get works_at_the_office;

  /// No description provided for @walks_regularly.
  ///
  /// In en, this message translates to:
  /// **'walks regularly'**
  String get walks_regularly;

  /// No description provided for @works_physically.
  ///
  /// In en, this message translates to:
  /// **'works physically'**
  String get works_physically;

  /// No description provided for @is_mostly_at_home.
  ///
  /// In en, this message translates to:
  /// **'is mostly at home'**
  String get is_mostly_at_home;

  /// No description provided for @do_you_workout.
  ///
  /// In en, this message translates to:
  /// **'Do you workout?'**
  String get do_you_workout;

  /// No description provided for @it_is_important_to_take_into.
  ///
  /// In en, this message translates to:
  /// **'It is important to take into consideration the activity level for a {gender} who wants to {objective} and {typicalDay}'**
  String it_is_important_to_take_into(
    String gender,
    String objective,
    String typicalDay,
  );

  /// No description provided for @almost_nothing.
  ///
  /// In en, this message translates to:
  /// **'Almost nothing'**
  String get almost_nothing;

  /// No description provided for @lightly_active.
  ///
  /// In en, this message translates to:
  /// **'Lightly active (light exercise 1 to 3 days/week)'**
  String get lightly_active;

  /// No description provided for @moderately_active.
  ///
  /// In en, this message translates to:
  /// **'Moderately active (moderate exercise 3 to 5 days/week)'**
  String get moderately_active;

  /// No description provided for @very_active.
  ///
  /// In en, this message translates to:
  /// **'Very active (hard exercise 6 to 7 days/week)'**
  String get very_active;

  /// No description provided for @extra_active.
  ///
  /// In en, this message translates to:
  /// **'Extra active (extra-hard exercise 6 to 7 days/week)'**
  String get extra_active;

  /// No description provided for @super_active.
  ///
  /// In en, this message translates to:
  /// **'Super active (extra-hard exercise 6 to 7 days/week and a physical job)'**
  String get super_active;

  /// No description provided for @you_have_dietary_restrictions.
  ///
  /// In en, this message translates to:
  /// **'Do you have any dietary restrictions or allergies?'**
  String get you_have_dietary_restrictions;

  /// No description provided for @im_lactose_intolerant.
  ///
  /// In en, this message translates to:
  /// **'I\'m lactose intolerant'**
  String get im_lactose_intolerant;

  /// No description provided for @im_dont_eat_gluten.
  ///
  /// In en, this message translates to:
  /// **'I don\'t eat gluten'**
  String get im_dont_eat_gluten;

  /// No description provided for @im_vegetarian.
  ///
  /// In en, this message translates to:
  /// **'I\'m vegetarian'**
  String get im_vegetarian;

  /// No description provided for @im_vegan.
  ///
  /// In en, this message translates to:
  /// **'I\'m vegan'**
  String get im_vegan;

  /// No description provided for @mark_the_vegetables.
  ///
  /// In en, this message translates to:
  /// **'Mark the vegetables and legumes you don\'\'t want to include:'**
  String get mark_the_vegetables;

  /// No description provided for @mark_the_fruits.
  ///
  /// In en, this message translates to:
  /// **'Mark the fruits and snacks you don\'\'t want to include:'**
  String get mark_the_fruits;

  /// No description provided for @mark_the_cereals.
  ///
  /// In en, this message translates to:
  /// **'Mark the cereals you don\'\'t want to include:'**
  String get mark_the_cereals;

  /// No description provided for @mark_the_dairy.
  ///
  /// In en, this message translates to:
  /// **'Mark the dairy products you don\'\'t want to include:'**
  String get mark_the_dairy;

  /// No description provided for @mark_the_meats.
  ///
  /// In en, this message translates to:
  /// **'Mark the meats and poultry you don\'\'t want to include:'**
  String get mark_the_meats;

  /// No description provided for @data_processing.
  ///
  /// In en, this message translates to:
  /// **'Data processing'**
  String get data_processing;

  /// No description provided for @your_meal_plan_begin_calculated.
  ///
  /// In en, this message translates to:
  /// **'Your meal plan is begin calculated'**
  String get your_meal_plan_begin_calculated;

  /// No description provided for @analyzing_the_data.
  ///
  /// In en, this message translates to:
  /// **'Analyzing the data'**
  String get analyzing_the_data;

  /// No description provided for @men.
  ///
  /// In en, this message translates to:
  /// **'Men'**
  String get men;

  /// No description provided for @women.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get women;

  /// No description provided for @enter_your_email_to_get_your_personal_meal_plan.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to get your personal meal plan'**
  String get enter_your_email_to_get_your_personal_meal_plan;

  /// No description provided for @we_respect_your_privacy.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy and take protecting it very seriously — no spam.'**
  String get we_respect_your_privacy;

  /// No description provided for @your_Full_name.
  ///
  /// In en, this message translates to:
  /// **'Your Full name'**
  String get your_Full_name;

  /// No description provided for @full_name_required.
  ///
  /// In en, this message translates to:
  /// **'Full name is a required field'**
  String get full_name_required;

  /// No description provided for @your_Email_Address.
  ///
  /// In en, this message translates to:
  /// **'Your Email Address'**
  String get your_Email_Address;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noting_happingng.
  ///
  /// In en, this message translates to:
  /// **'Noting happingng'**
  String get noting_happingng;

  /// No description provided for @the_password_provided_weak.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get the_password_provided_weak;

  /// No description provided for @the_account_already_exists.
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get the_account_already_exists;

  /// No description provided for @something_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something is wrong! Try Again.'**
  String get something_wrong;

  /// No description provided for @your_account_not_valid.
  ///
  /// In en, this message translates to:
  /// **'your account is not valid so far! A verification emai has been sent to your email.'**
  String get your_account_not_valid;

  /// No description provided for @no_user_found.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get no_user_found;

  /// No description provided for @wrong_password_provided.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided for that user.'**
  String get wrong_password_provided;

  /// No description provided for @your_account_disabled.
  ///
  /// In en, this message translates to:
  /// **'Your account was disabled! Please contact us via email support@fitfood.com'**
  String get your_account_disabled;

  /// No description provided for @password_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get password_updated_successfully;

  /// No description provided for @password_must_be_6_characters_or_more.
  ///
  /// In en, this message translates to:
  /// **'The password must be 6 characters long or more.'**
  String get password_must_be_6_characters_or_more;

  /// No description provided for @only_alphabetical_characters.
  ///
  /// In en, this message translates to:
  /// **'Please enter only alphabetical characters.'**
  String get only_alphabetical_characters;

  /// No description provided for @only_numeric_characters.
  ///
  /// In en, this message translates to:
  /// **'Please enter only numeric characters.'**
  String get only_numeric_characters;

  /// No description provided for @ready_in.
  ///
  /// In en, this message translates to:
  /// **'Ready in'**
  String get ready_in;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @price_Servings.
  ///
  /// In en, this message translates to:
  /// **'Price/Servings'**
  String get price_Servings;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @equipments.
  ///
  /// In en, this message translates to:
  /// **'Equipments'**
  String get equipments;

  /// No description provided for @quick_summary.
  ///
  /// In en, this message translates to:
  /// **'Quick summary'**
  String get quick_summary;

  /// No description provided for @similar_items.
  ///
  /// In en, this message translates to:
  /// **'Similar items'**
  String get similar_items;

  /// No description provided for @nutritions.
  ///
  /// In en, this message translates to:
  /// **'Nutritions'**
  String get nutritions;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @bad_for_health_Nutrients.
  ///
  /// In en, this message translates to:
  /// **'Bad for health Nutrients.'**
  String get bad_for_health_Nutrients;

  /// No description provided for @of_Daily_needs.
  ///
  /// In en, this message translates to:
  /// **'of Daily needs.'**
  String get of_Daily_needs;

  /// No description provided for @good_for_health_Nutrients.
  ///
  /// In en, this message translates to:
  /// **'Good for health Nutrients.'**
  String get good_for_health_Nutrients;

  /// No description provided for @forr.
  ///
  /// In en, this message translates to:
  /// **'For'**
  String get forr;

  /// No description provided for @consistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get consistency;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @check_out_This_tasty_recipe.
  ///
  /// In en, this message translates to:
  /// **'check out This tasty recipe'**
  String get check_out_This_tasty_recipe;

  /// No description provided for @calcium.
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get calcium;

  /// No description provided for @dietary_Fiber.
  ///
  /// In en, this message translates to:
  /// **'Dietary Fiber'**
  String get dietary_Fiber;

  /// No description provided for @iron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get iron;

  /// No description provided for @sodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get sodium;

  /// No description provided for @vitamin_A.
  ///
  /// In en, this message translates to:
  /// **'vitamin A'**
  String get vitamin_A;

  /// No description provided for @vitamin_C.
  ///
  /// In en, this message translates to:
  /// **'Vitamin C'**
  String get vitamin_C;

  /// No description provided for @vitamin_B1.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B1'**
  String get vitamin_B1;

  /// No description provided for @vitamin_B2.
  ///
  /// In en, this message translates to:
  /// **'Vitamin B2'**
  String get vitamin_B2;

  /// No description provided for @remember_to_use_the_same_ingredient_portions.
  ///
  /// In en, this message translates to:
  /// **'Remember to use the same ingredient portions'**
  String get remember_to_use_the_same_ingredient_portions;

  /// No description provided for @tracked.
  ///
  /// In en, this message translates to:
  /// **'tracked'**
  String get tracked;

  /// No description provided for @search_food_or_ingredient.
  ///
  /// In en, this message translates to:
  /// **'Search food or ingredient'**
  String get search_food_or_ingredient;

  /// No description provided for @custom_entry.
  ///
  /// In en, this message translates to:
  /// **'Custom entry'**
  String get custom_entry;

  /// No description provided for @overall_added.
  ///
  /// In en, this message translates to:
  /// **'Overall added'**
  String get overall_added;

  /// No description provided for @custom_entry_uppercase.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM ENTRY'**
  String get custom_entry_uppercase;

  /// No description provided for @search_results.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get search_results;

  /// No description provided for @we_dit_our_best.
  ///
  /// In en, this message translates to:
  /// **'We did our best, but it seems like there is no'**
  String get we_dit_our_best;

  /// No description provided for @you_can_add_custom_food.
  ///
  /// In en, this message translates to:
  /// **'You can add custom food instead'**
  String get you_can_add_custom_food;

  /// No description provided for @there.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get there;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @required_information.
  ///
  /// In en, this message translates to:
  /// **'Required information'**
  String get required_information;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @description_required.
  ///
  /// In en, this message translates to:
  /// **'Description is a required field'**
  String get description_required;

  /// No description provided for @calories_required.
  ///
  /// In en, this message translates to:
  /// **'Calories is a required field'**
  String get calories_required;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @serving_size.
  ///
  /// In en, this message translates to:
  /// **'Serving size'**
  String get serving_size;

  /// No description provided for @number_of_servings.
  ///
  /// In en, this message translates to:
  /// **'Number of servings'**
  String get number_of_servings;

  /// No description provided for @number_of_serving_required.
  ///
  /// In en, this message translates to:
  /// **'Number of serving is a required field'**
  String get number_of_serving_required;

  /// No description provided for @serving_size_required.
  ///
  /// In en, this message translates to:
  /// **'Serving size is a required field'**
  String get serving_size_required;

  /// No description provided for @add_custom_food.
  ///
  /// In en, this message translates to:
  /// **'Add custom food'**
  String get add_custom_food;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @date_out_of_range.
  ///
  /// In en, this message translates to:
  /// **'Date out of range'**
  String get date_out_of_range;

  /// No description provided for @date_required.
  ///
  /// In en, this message translates to:
  /// **'Date is a required field'**
  String get date_required;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'progress'**
  String get progress;

  /// No description provided for @second_snack_time.
  ///
  /// In en, this message translates to:
  /// **'Second snack time'**
  String get second_snack_time;

  /// No description provided for @first_snack_time.
  ///
  /// In en, this message translates to:
  /// **'First snack time'**
  String get first_snack_time;

  /// No description provided for @time_to_open_your_meal_plan.
  ///
  /// In en, this message translates to:
  /// **'time to open your meal plan'**
  String get time_to_open_your_meal_plan;

  /// No description provided for @click_here_and_see.
  ///
  /// In en, this message translates to:
  /// **'Click here and see what meal plan has prepared for you'**
  String get click_here_and_see;

  /// No description provided for @enjoy_your_breakfast.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your breakfast'**
  String get enjoy_your_breakfast;

  /// No description provided for @enjoy_your_lunch.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your lunch'**
  String get enjoy_your_lunch;

  /// No description provided for @enjoy_your_dinner.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your dinner'**
  String get enjoy_your_dinner;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @connexion.
  ///
  /// In en, this message translates to:
  /// **'Connexion'**
  String get connexion;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @theme_preview.
  ///
  /// In en, this message translates to:
  /// **'Theme Preview'**
  String get theme_preview;

  /// No description provided for @view_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'View and edit your profile'**
  String get view_edit_profile;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get notifications;

  /// No description provided for @receive_notifications.
  ///
  /// In en, this message translates to:
  /// **'Receive push notifications'**
  String get receive_notifications;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @dark_mode_description.
  ///
  /// In en, this message translates to:
  /// **'Enable dark mode to reduce screen brightness'**
  String get dark_mode_description;

  /// No description provided for @dark_mode_enabled.
  ///
  /// In en, this message translates to:
  /// **'Dark mode enabled'**
  String get dark_mode_enabled;

  /// No description provided for @light_mode_enabled.
  ///
  /// In en, this message translates to:
  /// **'Light mode enabled'**
  String get light_mode_enabled;

  /// No description provided for @system_theme.
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get system_theme;

  /// No description provided for @system_theme_description.
  ///
  /// In en, this message translates to:
  /// **'Use the device’s default theme'**
  String get system_theme_description;

  /// No description provided for @system_theme_enabled.
  ///
  /// In en, this message translates to:
  /// **'System theme enabled'**
  String get system_theme_enabled;

  /// No description provided for @enable_dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme'**
  String get enable_dark_theme;

  /// No description provided for @autoplay_videos.
  ///
  /// In en, this message translates to:
  /// **'Auto-play Videos'**
  String get autoplay_videos;

  /// No description provided for @videos_play_auto.
  ///
  /// In en, this message translates to:
  /// **'Videos play automatically'**
  String get videos_play_auto;

  /// No description provided for @autoplay.
  ///
  /// In en, this message translates to:
  /// **'Auto-play'**
  String get autoplay;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get security;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @biometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometric;

  /// No description provided for @use_fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face ID'**
  String get use_fingerprint;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms;

  /// No description provided for @communication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get communication;

  /// No description provided for @marketing_emails.
  ///
  /// In en, this message translates to:
  /// **'Marketing Emails'**
  String get marketing_emails;

  /// No description provided for @receive_promotional.
  ///
  /// In en, this message translates to:
  /// **'Receive promotional emails'**
  String get receive_promotional;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get feedback;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get app_version;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help;

  /// No description provided for @rate_app.
  ///
  /// In en, this message translates to:
  /// **'Rate This App'**
  String get rate_app;

  /// No description provided for @danger_zone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get danger_zone;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get disabled;

  /// No description provided for @profile_tapped.
  ///
  /// In en, this message translates to:
  /// **'Profile tapped'**
  String get profile_tapped;

  /// No description provided for @email_tapped.
  ///
  /// In en, this message translates to:
  /// **'Email tapped'**
  String get email_tapped;

  /// No description provided for @phone_tapped.
  ///
  /// In en, this message translates to:
  /// **'Phone Number tapped'**
  String get phone_tapped;

  /// No description provided for @change_password_tapped.
  ///
  /// In en, this message translates to:
  /// **'Change Password tapped'**
  String get change_password_tapped;

  /// No description provided for @privacy_tapped.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy tapped'**
  String get privacy_tapped;

  /// No description provided for @terms_tapped.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service tapped'**
  String get terms_tapped;

  /// No description provided for @feedback_tapped.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback tapped'**
  String get feedback_tapped;

  /// No description provided for @help_tapped.
  ///
  /// In en, this message translates to:
  /// **'Help & Support tapped'**
  String get help_tapped;

  /// No description provided for @rate_tapped.
  ///
  /// In en, this message translates to:
  /// **'Rate App tapped'**
  String get rate_tapped;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @language_changed.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get language_changed;

  /// No description provided for @logout_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logout_confirm;

  /// No description provided for @delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get delete_confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @logged_out.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get logged_out;

  /// No description provided for @delete_requested.
  ///
  /// In en, this message translates to:
  /// **'Account deletion requested'**
  String get delete_requested;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
