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
      return FormatException(L.purchaseErrorReceiptInUse(accountName));
    case PurchasesErrorCode.invalidAppUserIdError:
      return FormatException(L.purchaseErrorUserNotFound('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.operationAlreadyInProgressError:
      return FormatException(L.purchaseErrorOperationInProgress);
    case PurchasesErrorCode.unknownBackendError:
      return FormatException(L.purchaseErrorUnexpectedBackend('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.invalidAppleSubscriptionKeyError:
      return FormatException(L.purchaseErrorInvalidCredentials('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.ineligibleError:
      return FormatException(L.purchaseErrorInvalidCredentials('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.insufficientPermissionsError:
      return FormatException(L.purchaseErrorInsufficientPermissions(accountName));
    case PurchasesErrorCode.paymentPendingError:
      return FormatException(L.purchaseErrorPaymentPending(accountName, storeName));
    case PurchasesErrorCode.invalidSubscriberAttributesError:
      return FormatException(L.purchaseErrorInvalidCredentials('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.logOutWithAnonymousUserError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.configurationError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.unsupportedError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.emptySubscriberAttributesError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.productDiscountMissingIdentifierError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.unknownNonNativeError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.productDiscountMissingSubscriptionGroupIdentifierError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.customerInfoError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.systemInfoError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.beginRefundRequestError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.productRequestTimeout:
      return FormatException(L.purchaseErrorTimeout('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.apiEndpointBlocked:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.invalidPromotionalOfferError:
      return FormatException(L.purchaseErrorUnknown('${exception.message}:${exception.details}'));
    case PurchasesErrorCode.offlineConnectionError:
      return FormatException(L.purchaseErrorNetworkError('${exception.message}:${exception.details}'));
  }
}
