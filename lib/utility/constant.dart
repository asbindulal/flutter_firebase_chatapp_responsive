import 'package:chatapp/utility/usermodal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const black = Color.fromARGB(255, 0, 0, 0);
const grey = Color.fromARGB(255, 243, 243, 243);
const darkGrey = Color.fromARGB(255, 120, 120, 120);
const white = Color.fromARGB(255, 255, 255, 255);
const blue = Color.fromARGB(251, 147, 129, 255);
const red = Color.fromARGB(255, 255, 146, 183);

//fontSize

double fontSizeAppBar = 27;
double fontSizetitle = 19;
double fontSizeSubtitle = 17;
double fontSize = 16;

googleFonts({
  fs,
  fw,
  color,
}) {
  return GoogleFonts.dosis(
    fontSize: fs,
    fontWeight: fw,
    color: color,
  );
}

//CurrentUSerDetails
UserModel currentUser = UserModel();

newSnackBar(BuildContext context, {title}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: red,
      content: Text(
        title,
      ),
    ),
  );
}
