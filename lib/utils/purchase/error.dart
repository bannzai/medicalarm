import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:medicalarm/utils/platform/platform.dart';
import 'package:medicalarm/features/localization/l.dart';

// See also: https://docs.revenuecat.com/docs/errors
Exception? mapToDisplayedException(PlatformException exception) {
  final errorCode = PurchasesErrorHelper.getErrorCode(exception);
  switch (errorCode) {
    case PurchasesErrorCode.unknownError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.purchaseCancelledError:
      // NOTE: This exception indicates that the User has canceled.
      // See more details: https://docs.revenuecat.com/docs/errors#--purchase_cancelled
      // > No action required. The user decided not to proceed with their in-app purchase.
      return null;
    case PurchasesErrorCode.storeProblemError:
      // NOTE: RevenueCat auto retring purchase request on backend services.
      // Medicalarm must not be handling error message.
      // See more detail: https://docs.revenuecat.com/docs/errors#--store_problem
      // > If everything was working while testing, you shouldn't have to do anything to handle this error in production. RevenueCat will automatically retry any purchase failures so no data is lost.
      // But, return ambigious error message to be the on the safe side
      return FormatException(L.purchaseErrorStoreProblem(storeName));
    case PurchasesErrorCode.purchaseNotAllowedError:
      // NOTE: Maybe simulator or emulators
      // See more details: https://docs.revenuecat.com/docs/errors#--purchase_not_allowed
      return FormatException(L.purchaseNotAllowed);
    case PurchasesErrorCode.purchaseInvalidError:
      // See more details: https://docs.revenuecat.com/docs/errors#-purchase_invalid
      return FormatException(L.purchaseErrorInvalidPayment);
    case PurchasesErrorCode.productNotAvailableForPurchaseError:
      // Maybe missed implement or User references older payment product.
      // See more details: https://docs.revenuecat.com/docs/errors#-product_not_available_for_purchase
      return FormatException(L.purchaseErrorProductUnavailable);
    case PurchasesErrorCode.productAlreadyPurchasedError:
      // User already has same product. Announcement to restore
      // See more details: https://docs.revenuecat.com/docs/errors#-product_already_purchased
      // > If this occurs in production, make sure the user restores purchases to re-sync any transactions with their current App User Id.
      return FormatException(L.purchaseErrorAlreadyPurchased);
    case PurchasesErrorCode.receiptAlreadyInUseError:
      return FormatException(L.purchaseErrorReceiptInUse(accountName));
    case PurchasesErrorCode.invalidReceiptError:
      return FormatException(L.purchaseErrorInvalidReceipt);
    case PurchasesErrorCode.missingReceiptFileError:
      return FormatException(L.purchaseErrorMissingReceipt(accountName));
    case PurchasesErrorCode.networkError:
      return FormatException(L.purchaseErrorNetwork);
    case PurchasesErrorCode.invalidCredentialsError:
      // Maybe developer or store settings error
      // See more details: https://docs.revenuecat.com/docs/errors#---invalid_credentials
      return FormatException(L.purchaseErrorInvalidCredentials('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.unexpectedBackendResponseError:
      // Maybe RevenueCat incident
      // See more details: https://docs.revenuecat.com/docs/errors#-unexpected_backend_response_error
      return FormatException(L.purchaseErrorUnexpectedBackend('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.receiptInUseByOtherSubscriberError:
      return FormatException('購入情報は別のユーザーで使用されています。端末にログインしている$accountNameを確認してください');
    case PurchasesErrorCode.invalidAppUserIdError:
      return FormatException('ユーザーが確認できませんでした。アプリを再起動の上再度お試しください。詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.operationAlreadyInProgressError:
      return FormatException(L.purchaseErrorOperationInProgress);
    case PurchasesErrorCode.unknownBackendError:
      // Maybe RevenueCat incident
      // See more details: https://docs.revenuecat.com/docs/errors#-unknown_backend_error
      return FormatException('現在購入ができません。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.invalidAppleSubscriptionKeyError:
      // Maybe developer setting error on AppStore
      // See more details: https://docs.revenuecat.com/docs/errors#-invalid_apple_subscription_key
      // > In order to provide Subscription Offers you must first generate a subscription key.
      return FormatException('購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.ineligibleError:
      // Invalidate user
      // See more details: https://docs.revenuecat.com/docs/errors#-ineligible_error
      return FormatException('お使いのユーザーでの購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.insufficientPermissionsError:
      return FormatException(L.purchaseErrorInsufficientPermissions(accountName));
    case PurchasesErrorCode.paymentPendingError:
      return FormatException(L.purchaseErrorPaymentPending(accountName, storeName));
    case PurchasesErrorCode.invalidSubscriberAttributesError:
      // See more details: https://docs.revenuecat.com/docs/errors#-invalid_subscriber_attributes
      return FormatException('購入に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.logOutWithAnonymousUserError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.configurationError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.unsupportedError:
      return FormatException(
          '原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: $errorCode 詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.emptySubscriberAttributesError:
      return FormatException('原因不明のエラーです。購入情報を事前に取得できませんでした。詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.productDiscountMissingIdentifierError:
      return FormatException(
          '原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: $errorCode 詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.unknownNonNativeError:
      return FormatException(
          '原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: $errorCode 詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.productDiscountMissingSubscriptionGroupIdentifierError:
      return FormatException(
          '原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: $errorCode 詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.customerInfoError:
      return FormatException(
          '顧客情報の取得に失敗しました。時間をおいて再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: コード: $errorCode ${exception.message}:${exception.details}');
    case PurchasesErrorCode.systemInfoError:
      return FormatException(
          '端末の設定に問題があります。確認して再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: $errorCode 詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.beginRefundRequestError:
      return FormatException(
          '返金処理が開始されています。確認して再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: $errorCode 詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.productRequestTimeout:
      return FormatException('タイムアウトしました。通信環境をお確かめの上再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.apiEndpointBlocked:
      return FormatException(
          '原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: $errorCode 詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.invalidPromotionalOfferError:
      return FormatException(
          '原因不明のエラーです。最新版にアップデートして再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。コード: $errorCode 詳細: ${exception.message}:${exception.details}');
    case PurchasesErrorCode.offlineConnectionError:
      return FormatException('通信不良です。通信環境をお確かめの上再度お試しください。解決しない場合は 設定 > 問い合わせ よりお問い合わせください。詳細: ${exception.message}:${exception.details}');
  }
}
