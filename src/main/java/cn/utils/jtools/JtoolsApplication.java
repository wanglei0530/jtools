package cn.utils.jtools;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
@MapperScan("cn.utils.jtools.mapper")
public class JtoolsApplication {

	public static void main(String[] args) {
		SpringApplication.run(JtoolsApplication.class, args);
	}

}
