#! /bin/bash
echo "Step 1/4 拉取master分支代码..."
sleep 1s;
cd /root/java_project/jtools
git checkout master
git pull

echo "Step 2/4 编译程序"
sleep 5s;
mvn clean install -Dmaven.test.skip=true

echo "Step 3/4 终止旧程序..."
PID=`ps -ef |grep "jtools-" |grep -v "grep" | awk '{print $2}'`
if [ ! -n "$PID" ]; then
  echo "程序没有在运行直接启动..."
else
  echo "杀死在运行程序PID: $PID"
  kill -9 $PID
  sleep 3s
fi

echo "Step 4/4 启动项目..."
nohup java -jar -Dspring.profiles.active=prod /root/java_project/jtools/target/jtools-1.0.0.jar & tail -50f /root/java_project/logs/info.log 2>&1 &