package com.xiaochouyou.oracle.source;

import com.xiaochouyou.oracle.DbConfig;
import org.apache.flink.api.common.restartstrategy.RestartStrategies;
import org.apache.flink.api.common.time.Time;
import org.apache.flink.configuration.Configuration;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.table.api.EnvironmentSettings;
import org.apache.flink.table.api.bridge.java.StreamTableEnvironment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Qing
 * @create 2022-10-22 19:53
 */
public class ReadTest {
    private static final Logger logger = LoggerFactory.getLogger(ReadTest.class);

    public static void main(String[] args) {

        // 1 环境配置
        EnvironmentSettings fsSettings = EnvironmentSettings.newInstance()
                .useBlinkPlanner()
                .inStreamingMode()
                .build();
        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        env.setRestartStrategy(RestartStrategies.fixedDelayRestart(20, Time.minutes(5)));
        StreamTableEnvironment tableEnv = StreamTableEnvironment.create(env, fsSettings);
        Configuration configuration = tableEnv.getConfig().getConfiguration();
        configuration.setString("table.exec.mini-batch.enabled", "true");
        configuration.setString("table.exec.mini-batch.allow-latency", "5 s");
        configuration.setString("table.exec.mini-batch.size", "50000");
        configuration.setString("table.optimizer.agg-phase-strategy", "TWO_PHASE");
        configuration.setString("table.local-time-zone", "Asia/Shanghai");

        // 数据源

        String tb_ywgl_ycsybz =
                "create table tb_ywgl_ycsybz(\n" +
                        "id              BIGINT,\n" +
                        "sqbz            STRING,\n" +
                        "region_id        STRING)\n" +
                        "with (\n" +
                        "'connector' = 'oracle-cdc',\n" +
                        "'hostname' = '"+ DbConfig.ORACLE_SERVER +"',\n" +
                        "'port' = '"+DbConfig.ORACLE_PORT+"',\n" +
                        "'username' = '"+DbConfig.ORACLE_USER+"',\n" +
                        "'password' = '"+DbConfig.ORACLE_PASSWD+"',\n" +
                        "'database-name' = '"+DbConfig.ORACLE_SID+"',\n" +
                        "'schema-name' = 'inventory' , \n" +
                        "'table-name' = 'products'  , \n" +
                        "'connection.pool.size' = '5',\n" +
                        "'table-name' = 'tb_ywgl_ycsybz',\n" +
                        "'scan.incremental.snapshot.enabled' = 'false')";
        tableEnv.executeSql(tb_ywgl_ycsybz);



    }
}
