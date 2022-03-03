import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Faultreport extends StatelessWidget {
  const Faultreport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: Get.size.width * 0.044),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.size.height * 0.05,
              ),
              Container(
                width: Get.size.width - (Get.size.width * 0.044),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    Container(
                      width: Get.size.width * 0.7,
                      child: Text(
                        '충전소고장제보',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Pretendard-SemiBold',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Get.size.height * 0.015),
              Text(
                '판교테크노밸리',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
              DropdownButton(
                value: '거리순',
                items: ['거리순', '가격순'].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (e) {},
              ),
              Row(
                children: [
                  Container(
                    height: Get.size.width * 0.056,
                    width: Get.size.width * 0.056,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff878686),
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width * 0.024,
                  ),
                  Container(
                    child: Text(
                      '커넥터연결오류',
                      style: TextStyle(
                        color: Color(0xff878686),
                        fontSize: 16,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Row(
                children: [
                  Container(
                    height: Get.size.width * 0.056,
                    width: Get.size.width * 0.056,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff878686),
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width * 0.024,
                  ),
                  Container(
                    child: Text(
                      'LCD 이상',
                      style: TextStyle(
                        color: Color(0xff878686),
                        fontSize: 16,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Row(
                children: [
                  Container(
                    height: Get.size.width * 0.056,
                    width: Get.size.width * 0.056,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff878686),
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width * 0.024,
                  ),
                  Container(
                    child: Text(
                      '통신 미연결',
                      style: TextStyle(
                        color: Color(0xff878686),
                        fontSize: 16,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Row(
                children: [
                  Container(
                    height: Get.size.width * 0.056,
                    width: Get.size.width * 0.056,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff878686),
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width * 0.024,
                  ),
                  Container(
                    child: Text(
                      '프로그램 오류',
                      style: TextStyle(
                        color: Color(0xff878686),
                        fontSize: 16,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Row(
                children: [
                  Container(
                    height: Get.size.width * 0.056,
                    width: Get.size.width * 0.056,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff878686),
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width * 0.024,
                  ),
                  Container(
                    child: Text(
                      '차단기 off',
                      style: TextStyle(
                        color: Color(0xff878686),
                        fontSize: 16,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.size.height * 0.03,
              ),
              Row(
                children: [
                  Container(
                    height: Get.size.width * 0.056,
                    width: Get.size.width * 0.056,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xff878686),
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.size.width * 0.024,
                  ),
                  Container(
                    child: Text(
                      '기타',
                      style: TextStyle(
                        color: Color(0xff878686),
                        fontSize: 16,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
