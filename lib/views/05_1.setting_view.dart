import 'package:flutter/material.dart';
import 'package:get/get.dart';

class setting extends StatelessWidget {
  const setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white24,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Center(
            child: Text(
          '앱설정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
        actions: [
          Container(
            child: const Icon(Icons.search_outlined),
            padding: EdgeInsets.symmetric(horizontal: 20),
          )
        ],
      ),
      body: Container(
        width: Get.width,
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Column(
          children: [
            Text('로그인정보'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('로그인 하세요'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Container(
                alignment: Alignment.centerLeft,
                child: Text('기록해놓은 내역들이 사라지지 않도록 5초만에 \n내 계정에 저장하세요')),
            SizedBox(
              height: Get.size.height * 0.2,
            ),
            Container(alignment: Alignment.centerLeft, child: Text('수신설정')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('정보 수신 동의'),
                Switch(
                    activeColor: Colors.green,
                    value: true,
                    onChanged: (chk) {
                      print(chk);
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('푸시 알림'),
                Switch(
                    activeColor: Colors.green,
                    value: true,
                    onChanged: (chk) {
                      print(chk);
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
