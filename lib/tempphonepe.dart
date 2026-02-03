// <?php
// ob_start(); // optional, but good safety net
// if (session_status() === PHP_SESSION_NONE) {
// session_start();
// }
//
// // =============================
// // PHONEPE CONFIGURATION FILE
// // =============================
//
// // Environment
// // define('PHONEPE_ENV', 'sandbox');
//
// // define('PHONEPE_CLIENT_ID', 'M22WT1JEYXRO5_2511121523');
// // define('PHONEPE_MERCHANT_ID', 'M22WT1JEYXRO5_2511121523');
//
// // define('PHONEPE_CLIENT_SECRET', 'ZjY4ZjA2ZWQtNmUwYy00NzRmLTk0NGYtMTAyMDVjMmM5Yjdi');
//
// // define('PHONEPE_BASE_URL', 'https://api-preprod.phonepe.com/apis/pg-sandbox'); // sandbox
//
// // define('PHONEPE_AUTH_URL', 'https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token');
//
//
//
//
// // Environment: 'sandbox' or 'production'
// define('PHONEPE_ENV', 'production');
//
// // Redirect and callback URLs
// define('PHONEPE_REDIRECT_URL', 'https://aiphc.in/phonepe_callback.php');
// define('PHONEPE_CALLBACK_URL', 'https://aiphc.in/phonepe_callback.php');
// define('PHONEPE_MONTHLY_REDIRECT_URL', 'https://aiphc.in/phonepe_monthly_callback.php');
// define('PHONEPE_MONTHLY_CALLBACK_URL', 'https://aiphc.in/phonepe_monthly_callback.php');
// define('PHONEPE_AUTOPAYCALLBACK_URL', 'https://aiphc.in/autopay_callback.php');
//
// // Credentials
// define('PHONEPE_CLIENT_ID', 'SU2508251710261230112223');
// define('PHONEPE_MERCHANT_ID', 'SU2508251710261230112223');
// define('PHONEPE_CLIENT_SECRET', '306c2ce3-373c-4bea-811f-12469a1b4d80');
//
// define('PHONEPE_BASE_URL', 'https://api.phonepe.com/apis/pg');
//
// define('PHONEPE_AUTH_URL', 'https://api.phonepe.com/apis/identity-manager/v1/oauth/token');
//
// // ======================================================
// // CLIENT VERSION
// // ======================================================
// define('PHONEPE_CLIENT_VERSION', '1');
//
// // ======================================================
// // OPTIONAL LOGGING
// // ======================================================
// define('PHONEPE_LOG_FILE', __DIR__ . '/phonepe_log.txt');
// if (!function_exists('phonepe_log')) {
// function phonepe_log($message) {
// file_put_contents(PHONEPE_LOG_FILE, date('[Y-m-d H:i:s] ') . $message . PHP_EOL, FILE_APPEND);
// }
// }
// ?>
//
//
//




