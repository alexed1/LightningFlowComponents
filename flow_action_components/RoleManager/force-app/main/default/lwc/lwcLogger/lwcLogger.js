

//WARNING inverted logOn because I can't figure out how to efficiently turn on logging

/* eslint-disable no-console */
const logger = (
    logOn = false,
    source = 'unspecified source',
    message,
    data,
) => {
    if (!logOn) {
        try {
            if (data) {
                console.log(
                    `${source}: ${message}`,
                    JSON.parse(JSON.stringify(data)),
                );
            } else {
                console.log(`${source}: ${message}`);
            }
        } catch (e) {
            if (data) {
                console.log(`${source}: ${message}`, data);
            } else {
                console.log(`${source}: ${message}`);
            }
        }
    }
};

const logError = (
    logOn = false,
    source = 'unspecified source',
    message,
    data,
) => {
    if (!logOn) {
        try {
            if (data) {
                console.log(
                    `${source}: ${message}`,
                    JSON.parse(JSON.stringify(data)),
                );
            } else {
                console.log(`${source}: ${message}`);
            }
        } catch (e) {
            if (data) {
                console.log(`${source}: ${message}`, data);
            } else {
                console.log(`${source}: ${message}`);
            }
        }
    }
};

export { logger, logError };
