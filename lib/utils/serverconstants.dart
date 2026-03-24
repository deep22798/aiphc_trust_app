class ServerConstants {
  // 🔗 Base URL
  static const String baseUrl = "https://trust.aiphc.in/";
  static const String api = "${baseUrl}api/";


  // 🔐 Auth
  static const String adminLogin = "${api}adminlogin";
  static const String userLogin  = "${api}userlogin";
  static const String resetPassword  = "${api}resetPassword";

  // 👤 Members
  static const String members      = "${api}members";
  static const String addMember    = "${api}addMember";
  static const String updateMember = "${api}updateMember";
  static const String deleteMember = "${api}deleteMember";

  // 🖼️ Banners
  static const String banners      = "${api}banners";
  static const String addBanner    = "${api}addBanner";
  static const String updateBanner = "${api}updateBanner";
  static const String deleteBanner = "${api}deleteBanner";

  // 🎭 Roles
  static const String roles      = "${api}roles";
  static const String addRole    = "${api}addRole";
  static const String updateRole = "${api}updateRole";
  static const String deleteRole = "${api}deleteRole";

  // 📜 Rules
  static const String rules      = "${api}rules";
  static const String addRule    = "${api}addRule";
  static const String updateRule = "${api}updateRule";
  static const String deleteRule = "${api}deleteRule";

  // 👤 Profile
  static const String profile      = "${api}profile";
  static const String addProfile    = "${api}addProfile";
  static const String updateProfile = "${api}updateProfile";
  static const String deleteProfile = "${api}deleteProfile";

  // 🌍 States
  static const String states      = "${api}states";
  static const String addState    = "${api}addState";
  static const String updateState = "${api}updateState";
  static const String deleteState = "${api}deleteState";

  // 🏙️ Districts
  static const String districts      = "${api}districts";
  static const String addDistrict    = "${api}addDistrict";
  static const String updateDistrict = "${api}updateDistrict";
  static const String deleteDistrict = "${api}deleteDistrict";

  // 🏘️ Blocks
  static const String blocks      = "${api}blocks";
  static const String addBlock    = "${api}addBlock";
  static const String updateBlock = "${api}updateBlock";
  static const String deleteBlock = "${api}deleteBlock";

  // 🖼️ Gallery Albums
  static const String galleryAlbums      = "${api}galleryAlbums";
  static const String addGalleryAlbum    = "${api}addGalleryAlbum";
  static const String updateGalleryAlbum = "${api}updateGalleryAlbum";
  static const String deleteGalleryAlbum = "${api}deleteGalleryAlbum";

  // 🖼️ Gallery Images
  static const String galleryImages      = "${api}galleryImages";
  static const String addGalleryImage    = "${api}addGalleryImage";
  static const String updateGalleryImage = "${api}updateGalleryImage";
  static const String deleteGalleryImage = "${api}deleteGalleryImage";

  // ℹ️ About Us
  static const String aboutUs      = "${api}aboutUs";
  static const String addAboutUs    = "${api}addAboutUs";
  static const String updateAboutUs = "${api}updateAboutUs";
  static const String deleteAboutUs = "${api}deleteAboutUs";

  // ℹ️ About Us
  static const String contactUs      = "${api}contactUs";
  static const String addContactUs    = "${api}addContactUs";
  static const String updateContactUs = "${api}updateContactUs";
  static const String deleteContactUs = "${api}deleteContactUs";

  // 👴 Pension Help
  static const String pensionHelpList      = "${api}pensionHelpList";
  static const String addPensionHelp       = "${api}addPensionHelp";
  static const String updatePensionHelp    = "${api}updatePensionHelp";
  static const String deletePensionHelp    = "${api}deletePensionHelp";

  // ✅ Success Stories
  static const String successList      = "${api}successList";
  static const String addSuccess       = "${api}addSuccess";
  static const String updateSuccess    = "${api}updateSuccess";
  static const String deleteSuccess    = "${api}deleteSuccess";

  // 🚀 Recent Initiatives
  static const String recentInitiativesList   = "${api}recentInitiativesList";
  static const String addRecentInitiative     = "${api}addRecentInitiative";
  static const String updateRecentInitiative  = "${api}updateRecentInitiative";
  static const String deleteRecentInitiative  = "${api}deleteRecentInitiative";

  // 📣 Campaigns
  static const String campaigns      = "${api}campaigns";
  static const String addCampaign    = "${api}addCampaign";
  static const String updateCampaign = "${api}updateCampaign";
  static const String deleteCampaign = "${api}deleteCampaign";

  // 🏷️ Campaign Categories
  static const String campaignCategories      = "${api}campaignCategories";
  static const String addCampaignCategory     = "${api}addCampaignCategory";
  static const String updateCampaignCategory  = "${api}updateCampaignCategory";
  static const String deleteCampaignCategory  = "${api}deleteCampaignCategory";

  // 👥 Team
  static const String teamList      = "${api}teamList";
  static const String addTeam       = "${api}addTeam";
  static const String updateTeam    = "${api}updateTeam";
  static const String deleteTeam    = "${api}deleteTeam";

  // 👥 Team
  static const String donations      = "${api}donations";
  static const String addDonation       = "${api}addDonation";
  static const String adddonations       = "${api}adddonations";
  static const String updateDonation    = "${api}updateDonation";
  static const String deleteDonation    = "${api}deleteDonation";


  static const String getPayments    = "${api}getPayments";
  static const String createSubscription    = "${api}createSubscription";

  static const String updateFcmToken    = "${api}updateFcmToken";
  static const String updateLocation    = "${api}updateLocation";
  static const String triggerEmergency    = "${api}triggerEmergency";
  static const String updateLiveLocation    = "${api}updateLiveLocation";
  static const String getActiveEmergencies    = "${api}getActiveEmergencies";
  static const String endEmergency    = "${api}endEmergency";


  static const String memberpic    = "https://trust.aiphc.in/uploads/member/";




  static const String create_payment_api    = "${api}create_payment_api";
  static const String updatesubscriptionid    = "${api}updatesubscriptionid";


  static const String adddkanyaadaan    = "${api}adddkanyaadaan";
  static const String getKanyadaanMembers    = "${api}getKanyadaanMembers";

  static const String updatekanyadaansts    = "${api}updatekanyadaansts";

  static const String payenvmainmode    = payenvmodetest;
  // static const String payenvmainmode    = payenvmodeprod;


  static const String payenvmode    = payenvmainmode=="SANDBOX"?"$payenvmodetest":"$payenvmodeprod";
  static const String PHONEPE_CLIENT_ID    = payenvmainmode=="SANDBOX"?"$PHONEPE_CLIENT_IDtest":"$PHONEPE_CLIENT_IDprod";
  static const String PHONEPE_MERCHANT_ID    = payenvmainmode=="SANDBOX"?"$PHONEPE_MERCHANT_IDtest":"$PHONEPE_MERCHANT_IDprod";
  static const String PHONEPE_CLIENT_SECRET    = payenvmainmode=="SANDBOX"?"$PHONEPE_CLIENT_SECRETtest":"$PHONEPE_CLIENT_SECRETprod";
  static const String PHONEPE_BASE_URL    = payenvmainmode=="SANDBOX"?"$PHONEPE_BASE_URLtest":"$PHONEPE_BASE_URLprod";
  static const String PHONEPE_AUTH_URL    = payenvmainmode=="SANDBOX"?"$PHONEPE_AUTH_URLtest":"$PHONEPE_AUTH_URLprod";
  static const String PHONEPE_AUTH_URLorder    = payenvmainmode=="SANDBOX"?"$PHONEPE_AUTH_URLtestorder":"$PHONEPE_AUTH_URLProdorder";
  static const String PHONEPE_AUTH_URLsubscription    = payenvmainmode=="SANDBOX"?"$PHONEPE_AUTH_URLtestsubscription":"$PHONEPE_AUTH_URLProdorder";


  static const String payenvmodetest    = "SANDBOX";
  static const String PHONEPE_MERCHANT_IDtest    = "UATM22WT1JEYXRO5";
  static const String PHONEPE_CLIENT_IDtest    = "UATM22WT1JEYXRO5_2602041";
  static const String PHONEPE_CLIENT_SECRETtest    = "ZGU2ZmQ3ODctZTRiOS00ZjQ2LTgyZmMtMWViYjM4ZTIxZGEz";
  static const String PHONEPE_BASE_URLtest    = "https://api-preprod.phonepe.com/apis/pg-sandbox";
  static const String PHONEPE_AUTH_URLtest    = "https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token";
  static const String PHONEPE_AUTH_URLtestorder = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/sdk/order";
  static const String PHONEPE_AUTH_URLtestsubscription = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/pay";

  static const String payenvmodeprod    = "PRODUCTION";
  static const String PHONEPE_CLIENT_IDprod    = "SU2508251710261230112223";
  static const String PHONEPE_MERCHANT_IDprod    = "M22WT1JEYXRO5";
  static const String PHONEPE_CLIENT_SECRETprod    = "306c2ce3-373c-4bea-811f-12469a1b4d80";
  static const String PHONEPE_BASE_URLprod    = "https://api.phonepe.com/apis/pg";
  static const String PHONEPE_AUTH_URLprod    = "https://api.phonepe.com/apis/identity-manager/v1/oauth/token";
  static const String PHONEPE_AUTH_URLProdorder =	"https://api.phonepe.com/apis/pg/checkout/v2/sdk/order";












  static const String autopaypayenvmainmode    = autopaypayenvmodetest;
  // static const String payenvmainmode    = payenvmodeprod;


  // static const String autopaypayenvmode    = autopaypayenvmainmode=="SANDBOX"?"$autopaypayenvmodetest":"$autopaypayenvmodeprod";

  static const String autopaymerchantid    = autopaypayenvmainmode=="SANDBOX"?"$testmerchantid":"$livemerchantid";
  static const String autopayclientid    = autopaypayenvmainmode=="SANDBOX"?"$testclientid":"$liveclientid";
  static const String autopaysecretid    = autopaypayenvmainmode=="SANDBOX"?"$testclientsecret":"$liveclientsecret";


  static const String autopaytoken    = autopaypayenvmainmode=="SANDBOX"?"$testtoken":"$livetoken";
  static const String autopayordertoken    = autopaypayenvmainmode=="SANDBOX"?"$testordertoken":"$liveordertoekn";
  static const String autopayorderstatus    = autopaypayenvmainmode=="SANDBOX"?"$testorderstatus":"$liveorderstatus";
  static const String autopaysubscriptionstatus    = autopaypayenvmainmode=="SANDBOX"?"$testsubscriptionstatus":"$livesubscriptionstatus";
  static const String autopaynotifyredeem    = autopaypayenvmainmode=="SANDBOX"?"$testnotifyredeem":"$livenotifyredeem";
  static const String autopayexecuteredem    = autopaypayenvmainmode=="SANDBOX"?"$testexecuteredem":"$liveexecuteredem";
  static const String autopayredemstatus    = autopaypayenvmainmode=="SANDBOX"?"$testredemstatus":"$liveredeemstatus";
  static const String autopaycancelsubscription    = autopaypayenvmainmode=="SANDBOX"?"$testcancelsubscription":"$livecancelsubscription";
  static const String autopayinitialrefund    = autopaypayenvmainmode=="SANDBOX"?"$testinitialrefund":"$liveinitiaterefund";
  static const String autopayrefundstatus    = autopaypayenvmainmode=="SANDBOX"?"$testrefundstatus":"$liverefundstatus";


  static const String autopaypayenvmodetest    = "SANDBOX";


  static const String testmerchantid    = "UATM22WT1JEYXRO5";
  static const String testclientid    = "UATM22WT1JEYXRO5_2602041";
  static const String testclientsecret    = "ZGU2ZmQ3ODctZTRiOS00ZjQ2LTgyZmMtMWViYjM4ZTIxZGEz";


  static const String testtoken    = "https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token";
  static const String testordertoken    = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/sdk/order";
  static const String testorderstatus = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/order/";
  static const String testsubscriptionstatus = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/subscriptions/";
  static const String testnotifyredeem = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/subscriptions/notify";
  static const String testexecuteredem = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/subscriptions/redeem";
  static const String testredemstatus = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/order/{merchantOrderId}/status";
  static const String testcancelsubscription = "https://api-preprod.phonepe.com/apis/pg-sandbox/checkout/v2/subscriptions/{merchantSubscriptionId}/cancel";
  static const String testinitialrefund = "https://api-preprod.phonepe.com/apis/pg-sandbox/payments/v2/refund";
  static const String testrefundstatus = "https://api-preprod.phonepe.com/apis/pg-sandbox/payments/v2/refund/{merchantRefundId}/status";

  static const String autopaypayenvmodeprod    = "PRODUCTION";



  static const String livemerchantid    = "SU2508251710261230112223";
  static const String liveclientid    = "M22WT1JEYXRO5";
  static const String liveclientsecret    = "306c2ce3-373c-4bea-811f-12469a1b4d80";
  static const String livetoken    = "https://api.phonepe.com/apis/identity-manager/v1/oauth/token";
  static const String liveordertoekn    = "https://api.phonepe.com/apis/pg/checkout/v2/sdk/order";
  static const String liveorderstatus =	"https://api.phonepe.com/apis/pg/checkout/v2/order/";
  static const String livesubscriptionstatus =	"https://api.phonepe.com/apis/pg/checkout/v2/subscriptions/";
  static const String livenotifyredeem =	"https://api.phonepe.com/apis/pg/checkout/v2/subscriptions/notify";
  static const String liveexecuteredem =	"https://api.phonepe.com/apis/pg/checkout/v2/subscriptions/redeem";
  static const String liveredeemstatus=	"https://api.phonepe.com/apis/pg/checkout/v2/order/{merchantOrderId}/status";
  static const String livecancelsubscription=	"https://api.phonepe.com/apis/pg/checkout/v2/subscriptions/{merchantSubscriptionId}/cancel";
  static const String liveinitiaterefund=	"https://api.phonepe.com/apis/pg/payments/v2/refund";
  static const String liverefundstatus=	"https://api.phonepe.com/apis/pg/payments/v2/refund/{merchantRefundId}/status";







}
