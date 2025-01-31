## 목적 및 설명

![Image](https://github.com/user-attachments/assets/6b7a468f-4b3d-445e-98e0-3ef52ed8f2bd)

하나의 VPC 내에 
각 서비스별로 ECR 엔드포인트 분리 요구사항을 
사전에 확인하고, 서비스별로 분리했을 경우 발생할 수 있는 문제를 미리 확인합니다.

SSM과 같은 공용 엔드포인트는 공용 서브넷에 배치하여 공용으로 사용하며,
각 서비스 별로 분리하여 사용해야하는 엔드포인트는 각 서비스 별로 생성합니다.
그리고 엔드포인트별로 각 서비스가 배치될 서브넷을 연결합니다. 

특이사항으로는 각 서비스별로 분리되는 엔드포인트의 Private DNS Name 옵션은 비활성화합니다.
각 엔드포인트의 DNS 고유 주소를 통해 요청해야 합니다.
반대로, 공용 Endpoint의 경우 Private DNS Name은 활성화합니다.

이를 기준으로 서비스별로 Endpoint를 나눌 것인지를 검토하기 위한 목적을 가진 테라폼 코드입니다.

다중으로 구성하는 경우, 위 '각 엔드포인트의 DNS 고유 주소를 통해 요청해야 합니다.' 내용에 따라 서비스별로 가이드가 제공되어야 합니다.


---

## 🔧 인프라 구성
- **VPC** (CIDR: 10.0.0.0/16)
- **Subnet**
  - 서비스 A: `ap-northeast-2a`, `ap-northeast-2c`
  - 서비스 B: `ap-northeast-2a`, `ap-northeast-2c`
  - Common : `ap-northeast-2a`, `ap-northeast-2c`
- **ECS 클러스터**
  - 서비스 A (ECR `service-a-repo` 사용)
  - 서비스 B (ECR `service-b-repo` 사용)
- **ECR**
  - `service-a-repo`: 서비스 A에서만 접근 가능
  - `service-b-repo`: 서비스 B에서만 접근 가능
- **VPC 엔드포인트**
  - ECR, S3, SSM 엔드포인트 포함
- **IAM Role**
  - 각 서비스별로 ECR 접근 권한을 분리