class ServerConstants {
  // 🔗 Base URL
  static const String baseUrl = "https://trust.aiphc.in/";
  static const String api = "${baseUrl}api/";


  // 🔐 Auth
  static const String adminLogin = "${api}adminlogin";
  static const String userLogin  = "${api}userlogin";

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
  static const String updateDonation    = "${api}updateDonation";
  static const String deleteDonation    = "${api}deleteDonation";





  static const String payenvmainmode    = "Test";

  static const String payenvmode    = payenvmainmode=="Test"?"$payenvmodetest":"$payenvmodeprod";
  static const String PHONEPE_CLIENT_ID    = payenvmainmode=="Test"?"$PHONEPE_CLIENT_IDtest":"$PHONEPE_CLIENT_IDprod";
  static const String PHONEPE_MERCHANT_ID    = payenvmainmode=="Test"?"$PHONEPE_MERCHANT_IDtest":"$PHONEPE_MERCHANT_IDprod";
  static const String PHONEPE_CLIENT_SECRET    = payenvmainmode=="Test"?"$PHONEPE_CLIENT_SECRETtest":"$PHONEPE_CLIENT_SECRETprod";
  static const String PHONEPE_BASE_URL    = payenvmainmode=="Test"?"$PHONEPE_BASE_URLtest":"$PHONEPE_BASE_URLprod";
  static const String PHONEPE_AUTH_URL    = payenvmainmode=="Test"?"$PHONEPE_AUTH_URLtest":"$PHONEPE_AUTH_URLprod";


  static const String payenvmodetest    = "sandbox";
  static const String PHONEPE_CLIENT_IDtest    = "M22WT1JEYXRO5_2511121523";
  static const String PHONEPE_MERCHANT_IDtest    = "PGTESTPAYUAT";
  static const String PHONEPE_CLIENT_SECRETtest    = "ZjY4ZjA2ZWQtNmUwYy00NzRmLTk0NGYtMTAyMDVjMmM5Yjdi";
  static const String PHONEPE_BASE_URLtest    = "https://api-preprod.phonepe.com/apis/pg-sandbox";
  static const String PHONEPE_AUTH_URLtest    = "https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token";




  static const String payenvmodeprod    = "production";
  static const String PHONEPE_CLIENT_IDprod    = "SU2508251710261230112223";
  static const String PHONEPE_MERCHANT_IDprod    = "SU2508251710261230112223";
  static const String PHONEPE_CLIENT_SECRETprod    = "306c2ce3-373c-4bea-811f-12469a1b4d80";
  static const String PHONEPE_BASE_URLprod    = "https://api.phonepe.com/apis/pg";
  static const String PHONEPE_AUTH_URLprod    = "https://api.phonepe.com/apis/identity-manager/v1/oauth/token";



}
