import 'dart:convert';
import 'package:fp_ppb_manga_app/models/manga_model.dart';
import 'package:http/http.dart' as http;

class MangaService {
  final baseUri = 'https://api.jikan.moe/v4/';

  Future<List<TopMangaModel>> fetchTopManga() async {
    final uri = Uri.parse('${baseUri}top/manga?limit=24');
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

  Future<List<MangaModel>> searchManga(String query) async {
    final uri = Uri.parse('${baseUri}manga?q=$query&limit=20');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final Map<String, dynamic> mangaList = data;
      final List<dynamic> mangaData = mangaList['data'];
      return mangaData.map((manga) => MangaModel.fromJson(manga)).toList();
    } else {
      throw Exception('Failed to search manga');
    }
  }
}