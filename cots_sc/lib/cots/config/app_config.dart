class AppConfig {
  static const String baseUrl = "https://rpblbedyqmnzpowbumzd.supabase.co";
  static const String anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwYmxiZWR5cW1uenBvd2J1bXpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxMjcxMjYsImV4cCI6MjA3MzcwMzEyNn0.QaMJlyqhZcPorbFUpImZAynz3o2l0xDfq_exf2wUrTs";
  
  static Map<String, String> get headers => {
    "apikey": anonKey,
    "Authorization": "Bearer $anonKey",
    "Content-Type": "application/json",

  };
}