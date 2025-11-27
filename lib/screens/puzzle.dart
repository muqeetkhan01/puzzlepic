// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:puzzle_app/widgets/bottom_nav.dart';
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
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200, // prevent huge images
        maxHeight: 1200,
        imageQuality: 90,
      );

      if (picked == null) return;

      File rawImage = File(picked.path);

      int rows, cols;
      if (widget.pieceCount == 5) {
        rows = 1;
        cols = 5;
      } else if (widget.pieceCount == 10) {
        rows = 2;
        cols = 5;
      } else if (widget.pieceCount == 25) {
        rows = 5;
        cols = 5;
      } else if (widget.pieceCount == 50) {
        rows = 10;
        cols = 5;
      } else {
        rows = 5;
        cols = 5;
      }

      double ratioX = cols.toDouble();
      double ratioY = rows.toDouble();

      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: rawImage.path,
        aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
        compressFormat: ImageCompressFormat.jpg, // FIXED PNG CRASH
        compressQuality: 95,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Image",
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(title: "Crop Image", aspectRatioLockEnabled: true),
        ],
      );

      if (cropped == null) {
        debugPrint("❌ Cropping canceled.");
        return;
      }

      File finalImage = File(cropped.path);
      setState(() => imageFile = finalImage);
    } catch (e) {
      debugPrint("❌ Image pick error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load image. Try again.")),
      );
    }
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
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _topBar(),
              SizedBox(height: 4.h),
              _header(),
              SizedBox(height: 3.h),
              _uploadCard(),
              SizedBox(height: imageFile != null ? 4.h : 2.h),
              if (imageFile != null) _startButton(),
              SizedBox(height: 4.h),
              _tipsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Row(
        children: [
          Icon(Icons.arrow_back, color: AppColors.white, size: 20.sp),
          SizedBox(width: 2.w),
          Text(
            "Back",
            style: GoogleFonts.poppins(
              fontSize: 17.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/logo.png',
                height: 12.h,
                width: 12.h,
                // color: Colors.white,
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.7, 0.7), duration: 800.ms),

        // Icon(Icons.extension, color: AppColors.neonBlue, size: 16.w),
        SizedBox(height: 1.h),
        Text(
          "Create Your Puzzle",
          style: GoogleFonts.montserrat(
            fontSize: 23.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.white,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "${widget.pieceCount} Piece Puzzle",
          style: GoogleFonts.poppins(fontSize: 16.sp, color: AppColors.white70),
        ),
      ],
    );
  }

  Widget _uploadCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppColors.white10,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColors.white20, width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                "Upload Your Photo",
                style: GoogleFonts.montserrat(
                  fontSize: 20.sp,
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 28.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.neonPink.withOpacity(0.7),
                      width: 2.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: imageFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_rounded,
                                size: 12.h,
                                color: AppColors.neonBlue,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                "Click to browse\nor drag & drop",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  color: AppColors.white70,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  imageFile!,
                                  height: 16.h,
                                  width: 16.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 1.5.h),
                              Text(
                                "Tap to change image",
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

  Widget _startButton() {
    return GestureDetector(
      onTap: () {
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
          gradient: LinearGradient(
            colors: [AppColors.neonPink, AppColors.puzzleRed],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.neonPink.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Start Puzzle",
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tipsSection() {
    return Column(
      children: [
        Text(
          "Make sure your image is bright & clear.\nCropping will auto-fit the puzzle grid.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14.sp, color: AppColors.white50),
        ),
      ],
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

class _PuzzleGameScreenState extends State<PuzzleGameScreen>
    with SingleTickerProviderStateMixin {
  late int rows;
  late int cols;
  List<ui.Image> tiles = [];
  List<int> tileOrder = [];

  bool loading = true;
  Timer? timer;
  int seconds = 0;
  ui.Image? fullImage;
  void _setGrid() {
    if (widget.pieceCount == 5) {
      rows = 1;
      cols = 5;
    } else if (widget.pieceCount == 10) {
      rows = 2;
      cols = 5;
    } else if (widget.pieceCount == 25) {
      rows = 5;
      cols = 5;
    } else if (widget.pieceCount == 50) {
      rows = 10;
      cols = 5;
    } else {
      rows = 5;
      cols = 5; // fallback
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    pulseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true); // 🔥 continuous pulse

    pulseAnimation = Tween<double>(begin: 0.9, end: 1.15).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
    _setGrid();
    _preparePuzzle();
    _startTimer();
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  late AnimationController pulseController;
  late Animation<double> pulseAnimation;
  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => seconds++);
    });
  }

  Future _preparePuzzle() async {
    // 1️⃣ Load the already-cropped image
    final data = await widget.imageFile.readAsBytes();
    fullImage = await decodeImageFromList(data);

    final img = fullImage!;
    final int imgW = img.width;
    final int imgH = img.height;

    // 2️⃣ Make width/height divisible by cols/rows (crop a tiny bit if needed)
    final int usableW = imgW - (imgW % cols);
    final int usableH = imgH - (imgH % rows);

    final int tileW = usableW ~/ cols;
    final int tileH = usableH ~/ rows;

    tiles.clear();

    // 3️⃣ Cut into tiles directly from the full (rectangular) image
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);

        canvas.drawImageRect(
          img,
          Rect.fromLTWH(
            (c * tileW).toDouble(),
            (r * tileH).toDouble(),
            tileW.toDouble(),
            tileH.toDouble(),
          ),
          Rect.fromLTWH(0, 0, tileW.toDouble(), tileH.toDouble()),
          Paint(),
        );

        final tileImg = await recorder.endRecording().toImage(tileW, tileH);
        tiles.add(tileImg);
      }
    }

    // 4️⃣ Shuffle order
    tileOrder = List.generate(tiles.length, (i) => i)..shuffle();

    setState(() => loading = false);
  }
  // void _swapTiles(int a, int b) {
  //   setState(() {
  //     final temp = tileOrder[a];
  //     tileOrder[a] = tileOrder[b];
  //     tileOrder[b] = temp;
  //   });

  //   _checkWin();
  // }

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
                    filter: ui.ImageFilter.blur(
                      sigmaX: 8,
                      sigmaY: 8,
                    ), // reduced blur
                    child: Container(
                      width: 80.w,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 5.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.22),
                          width: 1.2,
                        ),
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
                          Text("🎉", style: TextStyle(fontSize: 38.sp)),
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BottomNavScreen(selected: 0),
                                ),
                              );
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
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Column(
                children: [
                  SizedBox(height: 7.h),

                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "Time: $seconds s",
                        style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          color: AppColors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 3.h,
                        width: 3.h,
                        child: FloatingActionButton(
                          backgroundColor: canUndo
                              ? Colors.orangeAccent
                              : Colors.grey.shade600,
                          onPressed: canUndo ? undoLastMove : null,
                          child: Icon(
                            Icons.undo,
                            color: Colors.white,
                            size: 2.h,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),

                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: tiles.length == 50 ? 7.w : 2.5.w,
                        vertical: tiles.length == 50 ? 4.h : 2.h,
                      ),
                      itemCount: tiles.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemBuilder: (context, index) {
                        bool isSelected = index == selectedTileIndex;
                        bool isHover = index == hoverTileIndex;

                        return DragTarget<int>(
                          onWillAccept: (_) {
                            setState(() => hoverTileIndex = index);
                            return true;
                          },

                          onLeave: (_) {
                            setState(() => hoverTileIndex = null);
                          },

                          onAccept: (fromIndex) => _swapTiles(fromIndex, index),

                          builder: (context, _, __) {
                            return Draggable<int>(
                              data: index,
                              onDragStarted: () {
                                setState(() => selectedTileIndex = index);
                              },
                              onDragEnd: (_) {
                                setState(() {
                                  selectedTileIndex = null;
                                  hoverTileIndex = null;
                                });
                              },

                              feedback: AnimatedScale(
                                scale: 1.15,
                                duration: const Duration(milliseconds: 120),
                                child: _animatedTile(
                                  index,
                                  isSelected,
                                  isHover,
                                ),
                              ),

                              childWhenDragging: Opacity(
                                opacity: 0.25,
                                child: _animatedTile(index, false, false),
                              ),

                              child: _animatedTile(index, isSelected, isHover),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  int? selectedTileIndex;
  int? hoverTileIndex;

  int? lastSwapA;
  int? lastSwapB;

  bool swapAnimating = false;
  int? undoA;
  int? undoB;
  bool canUndo = false;
  void _swapTiles(int a, int b) async {
    // store undo info
    undoA = a;
    undoB = b;
    canUndo = true;

    setState(() {
      selectedTileIndex = a;
      hoverTileIndex = b;
      lastSwapA = a;
      lastSwapB = b;
      swapAnimating = true;
    });

    await Future.delayed(const Duration(milliseconds: 150));

    // perform swap
    final temp = tileOrder[a];
    tileOrder[a] = tileOrder[b];
    tileOrder[b] = temp;

    setState(() {});

    // highlight for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      swapAnimating = false;
      selectedTileIndex = null;
      hoverTileIndex = null;
      lastSwapA = null;
      lastSwapB = null;
    });

    _checkWin();
  }

  void undoLastMove() {
    if (!canUndo || undoA == null || undoB == null) return;

    setState(() {
      final temp = tileOrder[undoA!];
      tileOrder[undoA!] = tileOrder[undoB!];
      tileOrder[undoB!] = temp;

      // highlight undo tiles
      lastSwapA = undoA;
      lastSwapB = undoB;
      swapAnimating = true;
    });

    // disable undo after usage
    canUndo = false;

    // hold highlight
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        swapAnimating = false;
        lastSwapA = null;
        lastSwapB = null;
      });
    });
  }

  Widget _animatedTile(int index, bool isSelected, bool isHover) {
    bool isLastSwap =
        swapAnimating && (index == lastSwapA || index == lastSwapB);

    double pulseScale = pulseAnimation.value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isLastSwap
              ? Colors.orangeAccent
              : isSelected
              ? Colors.greenAccent
              : isHover
              ? Colors.yellowAccent
              : Colors.transparent,
          width: isLastSwap ? 6 : (isSelected || isHover ? 4 : 1),
        ),
        boxShadow: isLastSwap
            ? [
                BoxShadow(
                  color: Colors.orangeAccent.withOpacity(0.85),
                  blurRadius: 30 * pulseScale, // 🔥 glow also pulses
                  spreadRadius: 10 * pulseScale,
                ),
              ]
            : [],
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: isLastSwap
            ? pulseScale // 🔥 swapped tiles pulse
            : isSelected || isHover
            ? 1.12
            : 1.0,
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: RawImage(image: tiles[tileOrder[index]], fit: BoxFit.cover),
        ),
      ),
    );
  }
}
