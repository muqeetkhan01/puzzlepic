// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:puzzle_app/widgets/bottom_nav.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../config/colors.dart';
import 'package:http/http.dart' as http;

import '../config/cloudinary_config.dart';
// -------------------------------------------------------
//  PUZZLE SCREEN (Upload Image)
// -------------------------------------------------------

class PuzzleScreen extends StatefulWidget {
  final int pieceCount;
  bool isMultiplayer;
  PuzzleScreen({
    super.key,
    required this.pieceCount,
    this.isMultiplayer = false,
  });

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  String? multiplayerMode; // "host" or "join"
  String? roomId;
  int code = 0;
  String hostId = "";
  String participantId = "";
  bool isHost = false;
  String status = "waiting";
  File? imageFile;
  Future<String?> uploadPuzzleImageToCloudinary(File file) async {
    try {
      final uri = Uri.parse(
        "https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/upload",
      );

      final request = http.MultipartRequest("POST", uri)
        ..fields["upload_preset"] = CloudinaryConfig.uploadPreset
        ..files.add(await http.MultipartFile.fromPath("file", file.path));

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      final data = jsonDecode(resBody);

      if (data["secure_url"] == null) {
        print("❌ Cloudinary upload FAILED");
        return null;
      }

      print("✅ Uploaded Puzzle Image: ${data["secure_url"]}");
      return data["secure_url"];
    } catch (e) {
      print("❌ Cloudinary Exception: $e");
      return null;
    }
  }

  Future pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 90,
      );

      if (picked == null) return;

      File rawImage = File(picked.path);

      // Apply cropping
      int rows, cols;
      switch (widget.pieceCount) {
        case 9:
          rows = 3;
          cols = 3;
          break;
        case 16:
          rows = 4;
          cols = 4;
          break;
        case 25:
          rows = 5;
          cols = 5;
          break;
        case 50:
          rows = 10;
          cols = 5;
          break;
        default:
          rows = 3;
          cols = 3;
          break;
      }

      double ratioX = cols.toDouble();
      double ratioY = rows.toDouble();

      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: rawImage.path,
        aspectRatio: CropAspectRatio(ratioX: ratioX, ratioY: ratioY),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 95,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Image",
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,

            // 🚫 Hide ALL bottom controls (removes the scale slider)
            hideBottomControls: true,
          ),
          IOSUiSettings(
            title: "Crop Image",
            aspectRatioLockEnabled: true,

            // 🚫 iOS equivalent — hides rotate/scale options
            showCancelConfirmationDialog: false,
          ),
        ],
      );
      if (cropped == null) return;

      File finalImage = File(cropped.path);
      setState(() => imageFile = finalImage);

      // 🔥 IF MULTIPLAYER HOST → create the game first
      // 🔥 Host uploads + creates game
      if (widget.isMultiplayer && multiplayerMode == "host") {
        // CREATE GAME FIRST
        code = await _createMultiplayerGame();
        FirebaseFirestore.instance
            .collection("multiplayer_games")
            .doc(code.toString())
            .snapshots()
            .listen((doc) {
              if (!doc.exists) return;
              final data = doc.data()!;
              setState(() {
                participantId = data["participantId"];
              });
            });
        // UPLOAD IMAGE TO CLOUDINARY
        String? imageUrl = await uploadPuzzleImageToCloudinary(finalImage);

        if (imageUrl == null) {
          print("❌ Cloudinary upload failed — cannot start game");
          return;
        }

        // SAVE PUBLIC URL TO FIRESTORE
        await FirebaseFirestore.instance
            .collection("multiplayer_games")
            .doc(code.toString())
            .update({"imageUrl": imageUrl});

        _showHostGameCodePopup(code);
      }
    } catch (e) {
      print("Pick image error: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.isMultiplayer) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _showMultiplayerEntryDialog();
      });
    }
    if (widget.isMultiplayer) {
      FirebaseFirestore.instance
          .collection("multiplayer_games")
          .doc(code.toString())
          .snapshots()
          .listen((doc) {
            if (!doc.exists) return;
            final data = doc.data()!;
            setState(() {
              participantId = data["participantId"];
            });
          });
    }
  }

  void _showMultiplayerEntryDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 80.w,
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Multiplayer Mode",
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    _dialogButton(
                      title: "Host Game",
                      colors: [AppColors.neonPink, AppColors.puzzleRed],
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          multiplayerMode = "host";
                          isHost = true;
                        });
                      },
                    ),
                    SizedBox(height: 2.h),

                    _dialogButton(
                      title: "Join Game",
                      colors: [AppColors.neonBlue, AppColors.neonPink],
                      onTap: () {
                        Navigator.pop(context);
                        _showJoinCodeDialog();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showJoinCodeDialog() {
    TextEditingController codeCtrl = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return SizedBox(
          width: 80.w,
          height: 40.h,

          child: Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: 80.w,
                    height: 40.h,
                    padding: EdgeInsets.symmetric(
                      vertical: 3.h,
                      horizontal: 5.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Enter Game Code",
                          style: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 2.h),

                        Expanded(
                          child: TextField(
                            controller: codeCtrl,
                            style: GoogleFonts.poppins(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "12345",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.white54,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white30),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white70),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        _dialogButton(
                          title: "Join",
                          colors: [AppColors.neonPink, AppColors.puzzleRed],
                          onTap: () async {
                            Navigator.pop(context);

                            String entered = codeCtrl.text.trim();
                            if (entered.isEmpty) {
                              Get.back();
                              return;
                            }

                            final doc = await FirebaseFirestore.instance
                                .collection("multiplayer_games")
                                .doc(entered)
                                .get();

                            if (!doc.exists) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Invalid Code")),
                              );
                              Get.back();
                              return;
                            }

                            roomId = entered;
                            code = int.parse(entered);
                            multiplayerMode = "join";
                            isHost = false;

                            await FirebaseFirestore.instance
                                .collection("multiplayer_games")
                                .doc(entered)
                                .update({
                                  "participantId":
                                      FirebaseAuth.instance.currentUser!.uid,
                                });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PuzzleGameScreen(
                                  imageFile: File(""), // dummy file
                                  isMultiplayer: true,
                                  pieceCount: widget.pieceCount,
                                  code: code,
                                ),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dialogButton({
    required String title,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // UI BUILD
  // -------------------------------------------------------

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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                _topBar(),
                SizedBox(height: 2.h),
                _header(),
                SizedBox(height: 3.h),
                _uploadCard(),
                SizedBox(height: imageFile != null ? 4.h : 2.h),

                if (!widget.isMultiplayer && imageFile != null)
                  _soloStartButton(),

                if (widget.isMultiplayer &&
                    isHost &&
                    imageFile != null &&
                    participantId.isNotEmpty)
                  _hostStartGameButton(),

                SizedBox(height: 4.h),
                _tipsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        InkWell(
          onTap: () => Get.back(),
          child: Row(
            children: [
              Icon(Icons.arrow_back, color: Colors.white, size: 20.sp),
              SizedBox(width: 2.w),
              Text(
                "Back",
                style: GoogleFonts.poppins(
                  fontSize: 17.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: Offset(0.7, 0.7), duration: 800.ms),
        SizedBox(height: 1.h),
        Text(
          "Create Your Puzzle",
          style: GoogleFonts.montserrat(
            fontSize: 23.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "${widget.pieceCount} Piece Puzzle",
          style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.white70),
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
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),

              GestureDetector(
                onTap: () {
                  if (!widget.isMultiplayer) {
                    pickImage();
                  } else if (multiplayerMode == "host") {
                    pickImage();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Only host can upload an image.")),
                    );
                  }
                },
                child: Container(
                  height: 28.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.neonPink.withOpacity(0.7),
                      width: 2.5,
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
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(height: 3.h),
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
                                  color: Colors.white70,
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

  Widget _soloStartButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PuzzleGameScreen(
              imageFile: imageFile!,
              isMultiplayer: false,
              pieceCount: widget.pieceCount,
            ),
          ),
        );
      },
      child: _buildStartButtonUI("Start Puzzle"),
    );
  }

  Widget _hostStartGameButton() {
    return GestureDetector(
      onTap: () async {
        await FirebaseFirestore.instance
            .collection("multiplayer_games")
            .doc(code.toString())
            .update({"status": "started"});

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PuzzleGameScreen(
              imageFile: imageFile!,
              isMultiplayer: true,
              pieceCount: widget.pieceCount,
              code: code,
            ),
          ),
        );
      },
      child: _buildStartButtonUI("Start Multiplayer Game"),
    );
  }

  Widget _buildStartButtonUI(String text) {
    return Container(
      height: 6.h,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.neonPink, AppColors.puzzleRed],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 17.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showHostGameCodePopup(int code) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Share this code",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          "$code",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 34),
        ),
      ),
    );
  }

  Future<int> _createMultiplayerGame() async {
    final newCode = 10000 + (DateTime.now().millisecondsSinceEpoch % 90000);

    await FirebaseFirestore.instance
        .collection("multiplayer_games")
        .doc(newCode.toString())
        .set({
          "code": newCode,
          "hostId": FirebaseAuth.instance.currentUser!.uid,
          "participantId": "",
          "pieceCount": widget.pieceCount,
          "status": "waiting",
          "winner": "",
          "createdAt": DateTime.now().toIso8601String(),
        });

    return newCode;
  }

  Widget _tipsSection() {
    return Text(
      "Make sure your image is bright & clear.\nCropping will auto-fit the puzzle grid.",
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white54),
    );
  }
}

// -------------------------------------------------------
//  PUZZLE GAME SCREEN
// -------------------------------------------------------

// =========================
//  PUZZLE GAME SCREEN
//  FULL MULTIPLAYER FIXED
// =========================

class PuzzleGameScreen extends StatefulWidget {
  final File imageFile;
  final int pieceCount;
  final bool isMultiplayer;
  final int code;

  const PuzzleGameScreen({
    super.key,
    required this.imageFile,
    required this.pieceCount,
    this.isMultiplayer = false,
    this.code = 0,
  });

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen>
    with SingleTickerProviderStateMixin {
  late int rows;
  late int cols;
  bool puzzleSolved = false;
  // puzzle
  List<ui.Image> tiles = [];
  List<int> tileOrder = [];
  ui.Image? fullImage;
  bool loading = true;

  // timer
  Timer? timer;
  int seconds = 0;

  // multiplayer
  bool isHost = false;
  String hostId = "";
  String participantId = "";
  String status = "waiting";
  bool _resultSaved = false;

  // undo logic
  int? lastSwapA;
  int? lastSwapB;
  int? undoA;
  int? undoB;
  bool canUndo = false;
  bool swapAnimating = false;

  // animation
  late AnimationController pulseController;
  late Animation<double> pulseAnimation;

  @override
  void initState() {
    super.initState();

    setGrid();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.15,
    ).animate(pulseController);

    preparePuzzle();
    if (!widget.isMultiplayer) {
      startTimer();
    }

    if (widget.isMultiplayer) {
      listenMultiplayer();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    pulseController.dispose();
    super.dispose();
  }

  // ======================
  //  GRID SIZE
  // ======================

  void setGrid() {
    switch (widget.pieceCount) {
      case 9:
        rows = 3;
        cols = 3;
        break;
      case 16:
        rows = 4;
        cols = 4;
        break;
      case 25:
        rows = 5;
        cols = 5;
        break;
      case 50:
        rows = 10;
        cols = 5;
        break;
      default:
        rows = 3;
        cols = 3;
    }
  }

  // ======================
  //  MULTIPLAYER LISTENER
  // ======================
  Widget _waitingScreen() {
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset("assets/animation/waiting.json", height: 400),
              // SizedBox(height: 10),
              Text(
                participantId.isEmpty
                    ? "Waiting for participant to join..."
                    : "Participant joined!\nWaiting for host to start...",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void listenMultiplayer() {
    FirebaseFirestore.instance
        .collection("multiplayer_games")
        .doc(widget.code.toString())
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;

          final data = doc.data()!;

          setState(() {
            hostId = data["hostId"];
            participantId = data["participantId"];
            status = data["status"];
            isHost = FirebaseAuth.instance.currentUser!.uid == hostId;
          });
          if (status == "started" && timer == null) {
            startTimer();
          }
          // someone already won
          if (data["winner"] != "" && !_resultSaved) {
            _resultSaved = true;
            timer?.cancel();
            bool youWon =
                data["winner"] == FirebaseAuth.instance.currentUser!.uid;
            showMultiplayerPopup(youWon);
          }
        });
  }

  // ======================
  //  TIMER
  // ======================

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => seconds++);
    });
  }

  // ======================
  //  PREPARE PUZZLE
  // ======================

  Future<void> preparePuzzle() async {
    Uint8List imageBytes;

    if (widget.isMultiplayer && !isHost) {
      // participant loads host image
      final doc = await FirebaseFirestore.instance
          .collection("multiplayer_games")
          .doc(widget.code.toString())
          .get();

      final imageUrl = doc["imageUrl"];
      final response = await HttpClient().getUrl(Uri.parse(imageUrl));
      final downloaded = await response.close();
      imageBytes = await consolidateHttpClientResponseBytes(downloaded);
    } else {
      // host uses local image
      imageBytes = await widget.imageFile.readAsBytes();
    }

    fullImage = await decodeImageFromList(imageBytes);

    final img = fullImage!;
    final int side = img.width < img.height ? img.width : img.height;
    final int x = (img.width - side) ~/ 2;
    final int y = (img.height - side) ~/ 2;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawImageRect(
      img,
      Rect.fromLTWH(
        x.toDouble(),
        y.toDouble(),
        side.toDouble(),
        side.toDouble(),
      ),
      Rect.fromLTWH(0, 0, side.toDouble(), side.toDouble()),
      Paint(),
    );

    final squareImage = await recorder.endRecording().toImage(side, side);

    final tileSize = side ~/ rows;

    tiles.clear();

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final pic = ui.PictureRecorder();
        final cv = Canvas(pic);
        cv.drawImageRect(
          squareImage,
          Rect.fromLTWH(
            (c * tileSize).toDouble(),
            (r * tileSize).toDouble(),
            tileSize.toDouble(),
            tileSize.toDouble(),
          ),
          Rect.fromLTWH(0, 0, tileSize.toDouble(), tileSize.toDouble()),
          Paint(),
        );

        tiles.add(await pic.endRecording().toImage(tileSize, tileSize));
      }
    }

    tileOrder = List.generate(tiles.length, (i) => i)..shuffle();

    setState(() => loading = false);
  }

  // ======================
  //  CHECK WIN
  // ======================

  void checkWin() async {
    for (int i = 0; i < tileOrder.length; i++) {
      if (tileOrder[i] != i) return;
    }

    // Stop timer immediately
    timer?.cancel();
    timer = null;

    if (_resultSaved) return;
    _resultSaved = true;

    // ✅ Show complete image by hiding borders
    setState(() => puzzleSolved = true);

    // Wait briefly so user sees the final complete puzzle
    await Future.delayed(const Duration(milliseconds: 350));

    if (widget.isMultiplayer) {
      await declareWinner();
    } else {
      saveSoloResult();
      showSoloPopup();
    }
  }
  // ======================
  //  SOLO SAVE
  // ======================

  Future<void> saveSoloResult() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance.collection("puzzle_results").add({
        "userId": user.uid,
        "pieceCount": widget.pieceCount,
        "durationSeconds": seconds,
        "completedAt": DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  // ======================
  //  MULTIPLAYER WINNER
  // ======================

  Future<void> declareWinner() async {
    final uid = FirebaseAuth.instance.currentUser!.uid; // winner
    final now = DateTime.now().toIso8601String();

    // Fetch match data to get host & participant IDs
    final doc = await FirebaseFirestore.instance
        .collection("multiplayer_games")
        .doc(widget.code.toString())
        .get();

    final data = doc.data()!;
    final hostId = data["hostId"];
    final participantId = data["participantId"];

    final loserId = uid == hostId ? participantId : hostId;

    // Save full match results
    await FirebaseFirestore.instance.collection("multiplayer_results").add({
      "code": widget.code,
      "pieceCount": widget.pieceCount,
      "winnerId": uid,
      "loserId": loserId,
      "winnerTime": seconds,
      "loserTime": null, // will update once loser finishes too
      "startedAt": data["createdAt"],
      "finishedAt": now,
    });

    // Update game status (simple version)
    await FirebaseFirestore.instance
        .collection("multiplayer_games")
        .doc(widget.code.toString())
        .update({"winnerTime": seconds, "winner": uid, "status": "finished"});

    showMultiplayerPopup(true);
  }

  // ======================
  //  POPUP — SOLO
  // ======================

  void showSoloPopup() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Lottie.asset(
                  "assets/animation/Confetti.json",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                width: 80.w,
                padding: EdgeInsets.all(5.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "🎉 Puzzle Completed!",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Time: $seconds seconds",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    actionBtn("Go Home", () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BottomNavScreen(selected: 0),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ======================
  //  POPUP — MULTIPLAYER
  // ======================

  void showMultiplayerPopup(bool won) {
    final String motivationalMsg = won
        ? "Brilliant! Your puzzle skills are unmatched! 🔥"
        : "Don't worry! Every puzzle makes you sharper.\nYou're getting better every round! 💪";

    final String title = won ? "🎉 YOU WIN!" : "😔 YOU LOST";

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) {
        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 80.w,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.20),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: won
                          ? Colors.yellow.withOpacity(0.25)
                          : Colors.redAccent.withOpacity(0.25),
                      blurRadius: 20,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ICON
                    Icon(
                      won ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                      size: 70,
                      color: won ? Colors.yellow : Colors.redAccent,
                    ),

                    SizedBox(height: 2.h),

                    // TITLE
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 1.2.h),

                    // TIME TAKEN
                    won
                        ? Text(
                            "Your Time: ${seconds}s",
                            style: GoogleFonts.poppins(
                              fontSize: 17.sp,
                              color: Colors.white70,
                            ),
                          )
                        : SizedBox(),

                    SizedBox(height: 2.2.h),

                    // MOTIVATION MESSAGE
                    Text(
                      motivationalMsg,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 3.5.h),

                    // BUTTON
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
                        width: 55.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            "Go Home",
                            style: GoogleFonts.poppins(
                              fontSize: 17.sp,
                              color: Colors.white,
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
        );
      },
    );
  }

  Widget actionBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        width: 40.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFFA855F7), Color(0xFF9333EA)],
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ======================
  //  UI
  // ======================

  @override
  Widget build(BuildContext context) {
    if (widget.isMultiplayer && status != "started") {
      return _waitingScreen();
    } else {
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
                    buildTopBar(),
                    Expanded(child: buildPuzzleGrid()),
                  ],
                ),
        ),
      );
    }
  }

  Widget buildTopBar() {
    return Row(
      children: [
        Spacer(),
        Text(
          "Time: $seconds s",
          style: GoogleFonts.poppins(fontSize: 18.sp, color: AppColors.white),
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
            child: Icon(Icons.undo, color: Colors.white, size: 2.h),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget buildPuzzleGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double tileSizeW = (constraints.maxWidth * 0.92) / cols;
        double tileSizeH = (constraints.maxHeight * 0.92) / rows;
        double tileSize = tileSizeW < tileSizeH ? tileSizeW : tileSizeH;

        return Center(
          child: SizedBox(
            width: tileSize * cols,
            height: tileSize * rows,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tiles.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
              ),
              itemBuilder: (_, index) {
                return buildTile(index, tileSize);
              },
            ),
          ),
        );
      },
    );
  }

  // ======================
  //  TILE INTERACTION
  // ======================

  Widget buildTile(int index, double size) {
    bool isSelected = index == selectedTileIndex;
    bool isHover = index == hoverTileIndex;
    bool isLastSwap =
        swapAnimating && (index == lastSwapA || index == lastSwapB);

    return DragTarget<int>(
      onWillAccept: (_) {
        setState(() => hoverTileIndex = index);
        return true;
      },
      onLeave: (_) => setState(() => hoverTileIndex = null),
      onAccept: (fromIndex) => swapTiles(fromIndex, index),
      builder: (_, __, ___) {
        return Draggable<int>(
          data: index,
          feedback: SizedBox(
            width: size,
            height: size,
            child: animatedTile(index, isSelected, isHover),
          ),
          childWhenDragging: Opacity(
            opacity: 0.25,
            child: SizedBox(
              width: size,
              height: size,
              child: animatedTile(index, false, false),
            ),
          ),
          child: SizedBox(
            width: size,
            height: size,
            child: animatedTile(index, isSelected, isHover),
          ),
        );
      },
    );
  }

  // highlight states
  int? selectedTileIndex;
  int? hoverTileIndex;

  Future<void> swapTiles(int a, int b) async {
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

    // REAL SWAP
    final temp = tileOrder[a];
    tileOrder[a] = tileOrder[b];
    tileOrder[b] = temp;

    setState(() {});

    // REMOVE LONG DELAY
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      swapAnimating = false;
      selectedTileIndex = null;
      hoverTileIndex = null;
      lastSwapA = null;
      lastSwapB = null;
    });

    // CHECK WIN IMMEDIATELY
    checkWin();
  }

  void undoLastMove() {
    if (!canUndo || undoA == null || undoB == null) return;

    final temp = tileOrder[undoA!];
    tileOrder[undoA!] = tileOrder[undoB!];
    tileOrder[undoB!] = temp;

    setState(() {
      lastSwapA = undoA;
      lastSwapB = undoB;
      swapAnimating = true;
    });

    canUndo = false;

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        swapAnimating = false;
        lastSwapA = null;
        lastSwapB = null;
      });
    });
  }

  Widget animatedTile(int index, bool isSelected, bool isHover) {
    bool isLastSwap =
        swapAnimating && (index == lastSwapA || index == lastSwapB);
    double pulseScale = pulseAnimation.value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

        border: puzzleSolved
            ? null // ✅ Hide borders when solved
            : Border.all(
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
                  blurRadius: 30 * pulseScale,
                  spreadRadius: 10 * pulseScale,
                ),
              ]
            : [],
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: isLastSwap
            ? pulseScale
            : (isSelected || isHover)
            ? 1.12
            : 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: RawImage(image: tiles[tileOrder[index]], fit: BoxFit.cover),
        ),
      ),
    );
  }
}
