async function main() {
  const canvas = document.createElement("canvas");
  canvas.width = 960;
  canvas.height = 540;
  document.querySelector("body").appendChild(canvas);

  const ctx = canvas.getContext("2d");
  ctx.imageSmoothingEnabled = false;
  const layer1 = await loadImage("./layer-1.png");
  ctx.drawImage(layer1, 0, 0, canvas.width, canvas.height);
}
main();

function loadImage(src) {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.src = src;
    img.onload = () => resolve(img);
  });
}
