// lib/data/database.dart

import 'package:zari/models/contract_model.dart';
import 'package:zari/models/info_model.dart'; // 새로 추가

List<Contract> savedContracts = [];

// 생활비 절약 팁 목록 (새로 추가)
List<SavingTip> savingTips = [
  SavingTip(title: "알뜰교통카드 활용하기", content: "대중교통 이용 시 이동 거리에 비례하여 마일리지를 적립받을 수 있습니다. 월 15회 이상 이용 시 적립되며, 카드사 추가 할인까지 받으면 교통비를 크게 절약할 수 있습니다."),
  SavingTip(title: "통신비 절약", content: "알뜰폰 요금제를 사용하거나, 가족 결합 할인, 선택 약정 할인 제도를 적극적으로 활용하여 고정 지출인 통신비를 줄일 수 있습니다."),
  SavingTip(title: "식비 절약", content: "외식보다는 직접 요리하는 습관을 들이고, 장을 볼 때는 미리 계획을 세워 충동구매를 줄입니다. 대형마트의 마감 세일 시간을 활용하는 것도 좋은 방법입니다."),
];

// 계약 핵심 용어 목록 (새로 추가)
List<ContractTerm> contractTerms = [
  ContractTerm(term: "등기부등본", definition: "부동산의 소유권, 저당권 등 권리 관계가 기록된 공적인 문서입니다. 계약 전 반드시 확인하여 집주인이 실제 소유자인지, 집에 빚(근저당)이 얼마나 있는지 확인해야 합니다."),
  ContractTerm(term: "확정일자", definition: "임대차 계약서가 특정 날짜에 존재했다는 사실을 법적으로 증명하는 도장입니다. 전입신고와 함께 받아두어야 보증금을 보호받는 대항력과 우선변제권이 생깁니다."),
  ContractTerm(term: "대항력", definition: "임차인이 제3자(새로운 집주인 등)에게 임차권을 주장할 수 있는 권리입니다. 주택을 인도(이사)받고 전입신고를 마치면 다음 날 0시부터 효력이 발생합니다."),
  ContractTerm(term: "우선변제권", definition: "집이 경매로 넘어갈 경우, 다른 채권자들보다 먼저 보증금을 돌려받을 수 있는 권리입니다. 대항력과 확정일자를 모두 갖추어야 합니다."),
];