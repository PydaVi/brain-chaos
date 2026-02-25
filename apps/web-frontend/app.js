const products = [
  { id: "p1", name: "Chaos Hoodie", description: "Moletom para noites de incident response", price: 22990 },
  { id: "p2", name: "K8s Mug", description: "Caneca para deploy sem downtime", price: 4990 },
  { id: "p3", name: "RCA Notebook", description: "Caderno para post-mortem raiz", price: 3990 },
  { id: "p4", name: "Observability Tee", description: "Camiseta para quem monitora tudo", price: 8990 },
  { id: "p5", name: "Secure Keycap", description: "Keycap com token fake gravado", price: 2990 },
  { id: "p6", name: "Latency Sticker", description: "Sticker para lembrar de timeout e retry", price: 1490 }
];

const services = [
  { id: "web-frontend", path: "/health/web-frontend" },
  { id: "api-gateway", path: "/health/api-gateway" },
  { id: "orders-service", path: "/health/orders-service" },
  { id: "catalog-service", path: "/health/catalog-service" },
  { id: "payments-mock", path: "/health/payments-mock" }
];

const cart = new Map();

const grid = document.querySelector("#product-grid");
const tpl = document.querySelector("#product-template");
const cartItems = document.querySelector("#cart-items");
const subtotalNode = document.querySelector("#subtotal");
const totalNode = document.querySelector("#total");
const checkoutBtn = document.querySelector("#checkout-btn");
const checkoutResult = document.querySelector("#checkout-result");
const statusGrid = document.querySelector("#service-status");
const statusRefresh = document.querySelector("#status-refresh");

const formatBRL = (value) =>
  new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(value / 100);

function renderProducts() {
  for (const product of products) {
    const node = tpl.content.cloneNode(true);
    node.querySelector(".product-name").textContent = product.name;
    node.querySelector(".product-desc").textContent = product.description;
    node.querySelector(".product-price").textContent = formatBRL(product.price);
    node.querySelector(".add-btn").addEventListener("click", () => addToCart(product.id));
    grid.appendChild(node);
  }
}

function addToCart(productId) {
  const current = cart.get(productId) || 0;
  cart.set(productId, current + 1);
  renderCart();
}

function removeFromCart(productId) {
  const current = cart.get(productId) || 0;
  if (current <= 1) {
    cart.delete(productId);
  } else {
    cart.set(productId, current - 1);
  }
  renderCart();
}

function renderCart() {
  cartItems.innerHTML = "";
  if (cart.size === 0) {
    cartItems.innerHTML = "<p>Carrinho vazio. Escolha algo do catalogo.</p>";
  }

  let subtotal = 0;
  for (const [id, qty] of cart.entries()) {
    const product = products.find((p) => p.id === id);
    const total = product.price * qty;
    subtotal += total;

    const item = document.createElement("div");
    item.className = "cart-item";
    item.innerHTML = `
      <div>
        <strong>${product.name}</strong><br/>
        <small>${qty} x ${formatBRL(product.price)}</small>
      </div>
      <div>
        <strong>${formatBRL(total)}</strong><br/>
        <button class="ghost-btn" aria-label="remover">-1</button>
      </div>
    `;
    item.querySelector("button").addEventListener("click", () => removeFromCart(id));
    cartItems.appendChild(item);
  }

  subtotalNode.textContent = formatBRL(subtotal);
  totalNode.textContent = formatBRL(subtotal + 1990);
}

function checkout() {
  if (cart.size === 0) {
    checkoutResult.textContent = "Adicione itens antes de finalizar.";
    return;
  }
  const orderId = `ORD-${Date.now()}`;
  checkoutResult.textContent = `Pedido ${orderId} criado (simulado).`;
  cart.clear();
  renderCart();
}

async function checkServices() {
  statusGrid.innerHTML = "";
  for (const service of services) {
    const item = document.createElement("div");
    item.className = "status-pill";
    item.innerHTML = `<strong>${service.id}</strong><div>checando...</div>`;
    statusGrid.appendChild(item);

    try {
      const res = await fetch(service.path, { cache: "no-store" });
      if (!res.ok) {
        throw new Error(`HTTP ${res.status}`);
      }
      item.classList.add("status-ok");
      item.querySelector("div").textContent = "online";
    } catch (err) {
      item.classList.add("status-bad");
      item.querySelector("div").textContent = "offline";
    }
  }
}

checkoutBtn.addEventListener("click", checkout);
statusRefresh.addEventListener("click", checkServices);

renderProducts();
renderCart();
checkServices();
