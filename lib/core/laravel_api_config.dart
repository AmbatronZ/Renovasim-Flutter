class LaravelApiConfig {
  // Default URL for Laravel local server (change to http://10.0.2.2 on Android emulator to refer to host's localhost)
  static const String baseUrl = 'http://localhost:8080';
  
  // The API Key managed and generated from the Laravel API Manager panel
  static const String apiKey = 'rsk_renovasim_change_me_in_admin_panel';

  // ─── Estimation API (forwarded by Laravel to RAI backend at port 8000) ───
  static const String estimateEndpoint = '/api/v2/estimate';
  static const String estimateAIEndpoint = '/api/v2/estimate/ai';

  // ─── Public API v1 endpoints ────────────────────────────────────────────
  static const String roomsEndpoint = '/api/v1/rooms';
  static const String materialsEndpoint = '/api/v1/materials';
  static const String pricingPlansEndpoint = '/api/v1/pricing-plans';
  static const String projectsEndpoint = '/api/v1/projects';
  static const String estimationsEndpoint = '/api/v1/estimations';
}
