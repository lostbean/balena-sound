import BalenaAudio from './BalenaAudio'
import * as Gpio from 'onoff'

const PULSE_SERVER = process.env.PULSE_SERVER
const POWER_AMP_PIN = 26;

export default async function main () {

  // Connect to audio block server
  let client = new BalenaAudio(PULSE_SERVER)
  let info = await client.listen();
  console.log(info);

  // Initialize GPIO
  if (!Gpio.Gpio.accessible) {
    throw new Error("gpio not accessible!");
  }
  const powerPin = new Gpio.Gpio(POWER_AMP_PIN, 'out');
  powerPin.write(0);

  // Listen for play/stop events and enable amp power
  client.on('play', (_: any) => {
    console.log('Started playing!')
    powerPin.write(1);
  })
  client.on('stop', (_: any) => {
    console.log('Stopped playing!')
    powerPin.write(0);
  })

  // Set volume to 100%
  //await client.setVolume(100)

  // // Play with a decreasing volume pattern
  // let vol = 100
  // setInterval(async () => {
  //   await client.setVolume(vol)
  //   vol = vol === 0 ? 100 : vol - 10
  //   console.log(`Volume is ${await client.getVolume()}%`)
  // }, 500)
}

function shutdown() {
  console.info('Shuting down ...');
  console.info('GPIO terminated');
  console.info('tchau belo!');
  process.exit(0);
}

process.on('SIGHUP', shutdown);
process.on('SIGINT', shutdown);
process.on('SIGCONT', shutdown);
process.on('SIGTERM', shutdown);

process.on('uncaughtException', err => {
  console.error(`Uncaught Exception: ${err.message}`)
  console.info('GPIO terminated');
  process.exit(1)
})

main();