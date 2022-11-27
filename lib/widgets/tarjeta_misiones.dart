import 'package:cached_network_image/cached_network_image.dart';
import 'package:fichas/models/models.dart';
import 'package:flutter/material.dart';

class MisionesCard extends StatelessWidget {
  final Mision mision;

  const MisionesCard({
    Key? key,
    required this.mision,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 20),
        width: double.infinity,
        decoration: _cardBorders(),
        child: Column(
          // alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(mision.fotoUrl),
            _ProductDetails(
              title: "Vigencia:",
              subTitle: mision.vencimiento.split(" ")[0],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black54, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String subTitle;

  const _ProductDetails({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 70,
      decoration: _buildBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            subTitle,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage(this.url);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25), topLeft: Radius.circular(25)),
      child: SizedBox(
        width: double.infinity,
        // height: 400,
        child: CachedNetworkImage(
          placeholder: (context, url) => Image.asset(
            'assets/loading.gif',
            // height: 100,
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
          imageUrl: url!,
        ),
      ),
    );
  }
}
