package cn.utils.jtools.config;

import cn.hutool.core.util.StrUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.context.WebServerInitializedEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.stereotype.Component;

/**
 * @Description 动态获取tomcat启动端口，控制台打印项目访问地址
 * @author wanglei
 * @Date 2019-12-27 14:37
 **/
@Component
@Slf4j
public class ServerConfig implements ApplicationListener<WebServerInitializedEvent> {

	@Value("${spring.profiles.active}")
	private String profilesActive;

	private int serverPort;

	public int getPort() {
		return this.serverPort;
	}

	@Override
	public void onApplicationEvent(WebServerInitializedEvent event) {
		this.serverPort = event.getWebServer().getPort();
		//log.info("Get WebServer port {}", serverPort);
		if (!StrUtil.equals("prod", profilesActive)) {
			log.info("Project started successfully, address: http://localhost:{}", serverPort);
		}
	}

}
