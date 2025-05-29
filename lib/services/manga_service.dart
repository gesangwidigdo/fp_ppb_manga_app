import 'dart:convert';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:http/http.dart' as http;

class TopMangaService {
  final uri = Uri.parse('https://api.jikan.moe/v4/top/manga?limit=24');

  Future<List<TopMangaModel>> fetchTopManga() async {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final Map<String, dynamic> mangaList = data;
      final List<dynamic> mangaData = mangaList['data'];
      return mangaData.map((manga) => TopMangaModel.fromJson(manga)).toList();
    } else {
      throw Exception('Failed to load top manga');
    }
  }
}