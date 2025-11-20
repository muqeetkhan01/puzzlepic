import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../config/colors.dart';

// -------------------------------------------------------
//  PUZZLE SCREEN (Upload Image)
// -------------------------------------------------------

class PuzzleScreen extends StatefulWidget {
  final int pieceCount;

  const PuzzleScreen({super.key, required this.pieceCount});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  File? imageFile;

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: AppColors.white),
                    SizedBox(width: 2.w),
                    Text(
                      "Back to Menu",
                      style: GoogleFonts.poppins(
                        fontSize: 17.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              _uploadCard(),
              if (imageFile != null) SizedBox(height: 3.h),
              if (imageFile != null) _startButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.white20),
          ),
          child: Column(
            children: [
              Text(
                "Upload Your Photo",
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 30.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.white40, width: 2),
                  ),
                  child: Center(
                    child: imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined,
                                  size: 10.h, color: AppColors.white70),
                              SizedBox(height: 2.h),
                              Text(
                                "Drag and drop your\nimage here\n\nor click to browse",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  color: AppColors.white70,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  imageFile!,
                                  height: 18.h,
                                  width: 18.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "Click to change image",
                                style: GoogleFonts.poppins(
                                  fontSize: 15.sp,
                                  color: AppColors.white70,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _startButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (imageFile == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PuzzleGameScreen(
              imageFile: imageFile!,
              pieceCount: widget.pieceCount,
            ),
          ),
        );
      },
      child: Container(
        height: 7.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.greenAccent.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Start Puzzle",
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------
//  PUZZLE GAME SCREEN
// -------------------------------------------------------

class PuzzleGameScreen extends StatefulWidget {
  final File imageFile;
  final int pieceCount;

  const PuzzleGameScreen({
    super.key,
    required this.imageFile,
    required this.pieceCount,
  });

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen> {
  late int rows;
  late int cols;
  List<ui.Image> tiles = [];
  List<int> tileOrder = [];

  bool loading = true;
  Timer? timer;
  int seconds = 0;
  ui.Image? fullImage;

  @override
  void initState() {
    super.initState();
    rows = 5;
    cols = widget.pieceCount == 25 ? 5 : 10;
    _preparePuzzle();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => seconds++);
    });
  }

  Future _preparePuzzle() async {
    final data = await widget.imageFile.readAsBytes();
    fullImage = await decodeImageFromList(data);

    int w = fullImage!.width ~/ cols;
    int h = fullImage!.height ~/ rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        ui.PictureRecorder recorder = ui.PictureRecorder();
        Canvas canvas = Canvas(recorder);
        Paint paint = Paint();

        canvas.drawImageRect(
          fullImage!,
          Rect.fromLTWH(c * w.toDouble(), r * h.toDouble(), w.toDouble(), h.toDouble()),
          Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
          paint,
        );

        final tileImage =
            await recorder.endRecording().toImage(w, h);

        tiles.add(tileImage);
      }
    }

    tileOrder = List.generate(tiles.length, (i) => i)..shuffle();
    setState(() => loading = false);
  }

  void _swapTiles(int a, int b) {
    setState(() {
      final temp = tileOrder[a];
      tileOrder[a] = tileOrder[b];
      tileOrder[b] = temp;
    });

    _checkWin();
  }

  void _checkWin() {
  for (int i = 0; i < tileOrder.length; i++) {
    if (tileOrder[i] != i) return;
  }

  timer?.cancel();

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: "",
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, anim1, anim2) {
      return Stack(
        children: [
          // 🎉 CONFETTI (Behind Popup)
          Positioned.fill(
            child: IgnorePointer(
              child: Lottie.asset(
                "assets/animation/Confetti.json",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🎯 MODERN POPUP (with underline-disabled media query)
          Center(
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(
                boldText: false,
                highContrast: false,
                accessibleNavigation: false,
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8), // reduced blur
                  child: Container(
                    width: 80.w,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.22), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.20),
                          blurRadius: 20,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🎉 Emoji
                        Text(
                          "🎉",
                          style: TextStyle(fontSize: 38.sp),
                        ),
                        SizedBox(height: 1.2.h),

                        // 🏆 Title
                        Text(
                          "Puzzle Completed!",
                          style: GoogleFonts.poppins(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 1.h),

                        // ⏱ Time
                        Text(
                          "Time: $seconds seconds",
                          style: GoogleFonts.poppins(
                            fontSize: 17.sp,
                            color: Colors.white70,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // ✔ Continue Button
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 6.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFA855F7),
                                  Color(0xFF9333EA),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Continue",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: loading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Column(
                children: [
                  SizedBox(height: 10.h),

                  Text(
                    "Time: $seconds s",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      color: AppColors.white,
                    ),
                  ),

                  SizedBox(height: 14.h),
                  Expanded(child: _buildPuzzleGrid()),
                ],
              ),
      ),
    );
  }

  Widget _buildPuzzleGrid() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
      itemCount: tiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return DragTarget<int>(
          onAccept: (fromIndex) => _swapTiles(fromIndex, index),
          builder: (context, _, __) {
            return Draggable<int>(
              data: index,
              feedback: _tile(tileOrder[index]),
              childWhenDragging: Container(color: AppColors.white20),
              child: _tile(tileOrder[index]),
            );
          },
        );
      },
    );
  }

  Widget _tile(int tileIndex) {
    return RawImage(
      image: tiles[tileIndex],
      fit: BoxFit.cover,
    );
  }
}
