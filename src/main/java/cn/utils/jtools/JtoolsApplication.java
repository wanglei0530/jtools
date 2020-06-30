package cn.utils.jtools;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class JtoolsApplication {

	public static void main(String[] args) {
		SpringApplication.run(JtoolsApplication.class, args);
	}

}
