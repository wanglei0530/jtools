package cn.utils.jtools.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author ：wanglei
 * @create ：2020-08-28 15:00
 * @description：
 */

@Slf4j
@Controller
public class MarkdownController {

	@GetMapping("markdown")
	public String markdown() {
		return "markdown";
	}
}
