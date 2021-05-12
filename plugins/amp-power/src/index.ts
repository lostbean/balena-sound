import BalenaAudio from './BalenaAudio'
import * as Gpio from 'pigpio'

const PULSE_SERVER = process.env.PULSE_SERVER
const POWER_AMP_PIN = 7;
const powerPin = new Gpio.Gpio(POWER_AMP_PIN, {mode: Gpio.Gpio.OUTPUT});

export default async function main () {

  // Connect to audio block server
  let client = new BalenaAudio(PULSE_SERVER)
  let info = await client.listen();
  console.log(info);

  powerPin.digitalWrite(0);

  // Listen for play/stop events
  client.on('play', (_: any) => {
    console.log('Started playing!')
    powerPin.digitalWrite(1);
    //console.log(data)
  })
  client.on('stop', (_: any) => {
    console.log('Stopped playing!')
    powerPin.digitalWrite(0);
    //console.log(data)
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
  Gpio.terminate();
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
  Gpio.terminate();
  console.info('GPIO terminated');
  process.exit(1)
})

main();