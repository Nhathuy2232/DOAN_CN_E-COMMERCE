import pino from 'pino';

const loggerOptions: any = {
  level: process.env.LOG_LEVEL ?? 'info',
};

if (process.env.NODE_ENV !== 'production') {
  loggerOptions.transport = {
    target: 'pino-pretty',
    options: {
      colorize: true,
      translateTime: 'SYS:standard',
    },
  };
}

const logger = pino(loggerOptions);

export default logger;

