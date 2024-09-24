import 'package:flutter/material.dart';

class RoundImageWidget extends StatelessWidget {
  final ImageProvider? image;
  final bool isContactPage;
  final String name; // This will be used to display the alphabet character

  const RoundImageWidget({
    super.key,
    this.image,
    this.isContactPage = false,
    required this.name,
    // Pass the name to display the first letter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isContactPage ? 50 : 100,
      height: isContactPage ? 50 : 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300], // Background color for the character circle
        image: image != null
            ? DecorationImage(
                fit: BoxFit.cover,
                image: image!,
              )
            : null, // No image if path is empty
      ),
      child: image == null
          ? Center(
              child: Text(
                (name.isNotEmpty && name != "Unknown")
                    ? name[0].toUpperCase()
                    : '?', // Display the first letter or a fallback
                style: TextStyle(
                  fontSize: isContactPage
                      ? 24
                      : 48, // Adjust font size based on the page
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }
}
