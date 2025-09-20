package com.example.zari;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// 이 어노테이션 하나로 필요한 기본 설정들이 모두 자동으로 구성됩니다.
@SpringBootApplication
public class ZariApplication {

    // Java 프로그램을 실행하는 main 메소드입니다.
    public static void main(String[] args) {
        // Spring Boot 애플리케이션을 실행하는 코드입니다.
        SpringApplication.run(ZariApplication.class, args);
    }

}