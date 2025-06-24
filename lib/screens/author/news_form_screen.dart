// lib/screens/author/news_form_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vartaa/models/author_news_controller.dart';
import 'package:vartaa/models/news_article.dart';

class NewsFormScreen extends StatefulWidget {
  final NewsArticle?
  article; // Opsional: jika untuk mengedit berita yang sudah ada

  const NewsFormScreen({super.key, this.article});

  @override
  State<NewsFormScreen> createState() => _NewsFormScreenState();
}

class _NewsFormScreenState extends State<NewsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _summaryController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;
  late TextEditingController _categoryController;
  late TextEditingController _tagsController;
  bool _isPublished = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.article?.title);
    _summaryController = TextEditingController(text: widget.article?.summary);
    _contentController = TextEditingController(text: widget.article?.content);
    _imageUrlController = TextEditingController(
      text: widget.article?.featuredImageUrl,
    );
    _categoryController = TextEditingController(text: widget.article?.category);
    _tagsController = TextEditingController(
      text: widget.article?.tags.join(', '),
    );
    _isPublished = widget.article?.isPublished ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final authorNewsController = Provider.of<AuthorNewsController>(
        context,
        listen: false,
      );

      final List<String> tagsList =
          _tagsController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      bool success;
      if (widget.article == null) {
        // Create new news
        success = await authorNewsController.createNews(
          title: _titleController.text,
          summary: _summaryController.text,
          content: _contentController.text,
          featuredImageUrl:
              _imageUrlController.text.isEmpty
                  ? null
                  : _imageUrlController.text,
          category: _categoryController.text,
          tags: tagsList,
          isPublished: _isPublished,
        );
      } else {
        // Update existing news
        success = await authorNewsController.updateNews(
          widget.article!.id,
          title: _titleController.text,
          summary: _summaryController.text,
          content: _contentController.text,
          featuredImageUrl:
              _imageUrlController.text.isEmpty
                  ? null
                  : _imageUrlController.text,
          category: _categoryController.text,
          tags: tagsList,
          isPublished: _isPublished,
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berita berhasil ${widget.article == null ? 'ditambahkan' : 'diperbarui'}!',
            ),
          ),
        );
        Navigator.of(context).pop(true); // Kembali dan beritahu berhasil
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal ${widget.article == null ? 'menambahkan' : 'memperbarui'} berita: ${authorNewsController.errorMessage}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authorNewsController = Provider.of<AuthorNewsController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.article == null ? 'Buat Berita Baru' : 'Edit Berita',
        ),
      ),
      body:
          authorNewsController.status == AuthorNewsStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Berita',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _summaryController,
                        decoration: const InputDecoration(
                          labelText: 'Ringkasan (Summary)',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ringkasan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Konten Berita',
                        ),
                        maxLines: 8,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konten tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'URL Gambar Utama (Featured Image URL)',
                        ),
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _categoryController,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kategori tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tagsController,
                        decoration: const InputDecoration(
                          labelText:
                              'Tags (pisahkan dengan koma, misal: tag1, tag2)',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _isPublished,
                            onChanged: (bool? value) {
                              setState(() {
                                _isPublished = value ?? false;
                              });
                            },
                          ),
                          const Text('Publikasikan Berita'),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.article == null
                                ? 'Buat Berita'
                                : 'Perbarui Berita',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
