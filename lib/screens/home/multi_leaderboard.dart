import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:puzzle_app/config/colors.dart';

class MyMultiplayerGamesScreen extends StatefulWidget {
  const MyMultiplayerGamesScreen({super.key});

  @override
  State<MyMultiplayerGamesScreen> createState() =>
      _MyMultiplayerGamesScreenState();
}

class _MyMultiplayerGamesScreenState extends State<MyMultiplayerGamesScreen> {
  int modeIndex = 2; // 0 = Daily, 1 = Weekly, 2 = All Time
  int pieceIndex = 0; // 0 = 9, 1 = 16, 2 = 25, 3 = 50

  String uid = FirebaseAuth.instance.currentUser!.uid;

  // ===============================
  // FIRESTORE QUERY
  // ===============================
  Stream<QuerySnapshot> _getMyGames() {
    int piece = [25, 50][pieceIndex];

    DateTime now = DateTime.now();
    DateTime filterDate;

    Query ref = FirebaseFirestore.instance
        .collection("multiplayer_games")
        .where("status", isEqualTo: "finished")
        .where("pieceCount", isEqualTo: piece);

    if (modeIndex == 0) {
      filterDate = DateTime(now.year, now.month, now.day);
      ref = ref.where(
        "createdAt",
        isGreaterThanOrEqualTo: filterDate.toIso8601String(),
      );
    } else if (modeIndex == 1) {
      filterDate = now.subtract(const Duration(days: 7));
      ref = ref.where(
        "createdAt",
        isGreaterThanOrEqualTo: filterDate.toIso8601String(),
      );
    }

    return ref.orderBy("createdAt", descending: true).snapshots();
  }
  // ===============================
  // UI BUILD
  // ===============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    // Icon(
                    //   Icons.sports_esports,
                    //   size: 24.sp,
                    //   color: Colors.yellowAccent,
                    // ),
                    // SizedBox(width: 2.w),
                    Text(
                      "Multiplayer Games",
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // TOP FILTERS: DAILY / WEEKLY / ALL TIME
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _toggleMode("Daily", 0),
                    _toggleMode("Weekly", 1),
                    _toggleMode("All Time", 2),
                  ],
                ),

                SizedBox(height: 2.5.h),

                // PIECE COUNT TOGGLE
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(26.sp),
                  ),
                  child: Row(
                    children: [
                      _togglePiece("25 Pieces", 0),
                      _togglePiece("50 Pieces", 1),
                    ],
                  ),
                ),

                SizedBox(height: 3.h),

                // LIST OF GAMES
                StreamBuilder<QuerySnapshot>(
                  stream: _getMyGames(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            "No multiplayer games found!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                      );
                    }

                    List allGames = snapshot.data!.docs;

                    // 🔥 LOCAL FILTER (hostId == me OR participantId == me)
                    List myGames = allGames.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data["hostId"] == uid ||
                          data["participantId"] == uid;
                    }).toList();

                    if (myGames.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            "No multiplayer games yet!",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: myGames.length,
                      itemBuilder: (_, i) {
                        final data = myGames[i].data() as Map<String, dynamic>;
                        return _gameCard(data);
                      },
                    );
                  },
                ),

                SizedBox(height: 6.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // TOGGLES
  // ===============================

  Widget _toggleMode(String label, int index) {
    bool active = index == modeIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => modeIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: .8.h),
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          decoration: BoxDecoration(
            color: active
                ? Colors.white.withOpacity(0.25)
                : Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(18.sp),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(active ? 1 : 0.7),
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _togglePiece(String label, int index) {
    bool active = index == pieceIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => pieceIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 1.2.h),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26.sp),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: active ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // GAME CARD (GLASS UI)
  // ===============================

  Widget _gameCard(Map<String, dynamic> d) {
    bool iWon = d["winner"] == uid;
    bool isHost = d["hostId"] == uid;

    String date = d["createdAt"].toString().split("T")[0];

    String myTime = "${d["winnerTime"] ?? '--'}s";

    // String oppTime = isHost
    //     ? "${d["participantTime"] ?? '--'}s"
    //     : "${d["hostTime"] ?? '--'}s";

    String opponent = isHost ? d["participantId"] : d["hostId"];

    return Container(
      margin: EdgeInsets.only(bottom: 2.2.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.sp),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.2.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              border: Border.all(
                color: Colors.white.withOpacity(0.20),
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(22.sp),
            ),
            child: Row(
              children: [
                // ----------- LEFT SIDE: WIN or LOSS -----------
                Text(iWon ? "🏆" : "❌", style: TextStyle(fontSize: 24.sp)),
                SizedBox(width: 3.w),

                // ----------- CENTER DETAILS -----------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        iWon ? "You Won!" : "You Lost",
                        style: GoogleFonts.poppins(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(height: 0.4.h),

                      Text(
                        "Puzzle: ${d["pieceCount"]} pieces",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),

                      // Text(
                      //   "Opponent: $opponent",
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 14.sp,
                      //     color: Colors.white70,
                      //   ),
                      // ),
                      Text(
                        "Role: ${isHost ? "Host" : "Participant"}",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),

                      Text(
                        "Game Code: ${d["code"]}",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),

                      Text(
                        date,
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),

                // ----------- RIGHT SIDE: TIMES -----------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      myTime,
                      style: GoogleFonts.poppins(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Time",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                    // SizedBox(height: 1.h),
                    // Text(
                    //   oppTime,
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 17.sp,
                    //     fontWeight: FontWeight.w600,
                    //     color: Colors.white70,
                    //   ),
                    // ),
                    // Text(
                    //   "Opponent",
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 13.sp,
                    //     color: Colors.white54,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
