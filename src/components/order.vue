<template>
  <div class="order" >
  
    <button
      ref="closeButton1"
      @click="$emit('close')"
      class="mdc-icon-button material-icons mdc-icon-button--close"
    >
      close
    </button>

    <transition name="fade">
      <div v-show="orderSended" class="order-sended-message">
        <h2>Заказ принят!</h2>
        <p>
          Курьер перезвонит вам по&nbsp;номеру {{ form.phone }}
          и&nbsp;договорится о&nbsp;встрече.
        </p>
        <button
          ref="closeButton2"
          @click="$emit('close')"
          class="mdc-button mdc-button--unelevated"
        >
          <span class="mdc-button__label">OK</span>
        </button>
      </div>
    </transition>
    <div style="overflow:auto;">
    <form v-if="!orderSended" @submit.prevent="sendOrder" style="height:100%;">
	
	
<div class="mdc-tab-scroller" style="">
  <div class="mdc-tab-scroller__scroll-area" style="">
    <div class="mdc-tab-scroller__scroll-content" style="/*overflow:auto;*/height: fit-content;overflow:auto;">
	
      <h1>Купить книгу</h1>

      <p>
        Стоимость одной книги: <big>{{ bookPrice }}&nbsp;руб.</big><br>
        Доставка по&nbsp;Москве (в пределах МКАД): <big>{{ deliveryPrice }}&nbsp;руб.</big>
      </p>

      <!--p>
        Укажите, пожалуйста, контактные данные и&nbsp;количество книг:
      </p-->

      <div class="input" style="margin-top: 2rem;">
        <div ref="nameTextfield" class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon">
          <i class="material-icons mdc-text-field__icon">perm_identity</i>
          <input v-model="form.name" type="text" class="mdc-text-field__input" autofocus required>
          <div class="mdc-notched-outline">
            <div class="mdc-notched-outline__leading"></div>
            <div class="mdc-notched-outline__notch">
              <label for="tf-outlined" class="mdc-floating-label">Ваше имя</label>
            </div>
            <div class="mdc-notched-outline__trailing"></div>
          </div>
        </div>
      </div>
      <div class="input">
        <div ref="phoneTextfield" class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon">
          <i class="material-icons mdc-text-field__icon">phone</i>
          <input v-model="form.phone" type="tel" class="mdc-text-field__input" required>
          <div class="mdc-notched-outline">
            <div class="mdc-notched-outline__leading"></div>
            <div class="mdc-notched-outline__notch">
              <label for="tf-outlined" class="mdc-floating-label">Номер телефона</label>
            </div>
            <div class="mdc-notched-outline__trailing"></div>
          </div>
        </div>
      </div>
      <div class="input">
        <div ref="emailTextfield" class="mdc-text-field mdc-text-field--outlined mdc-text-field--with-leading-icon">
          <i class="material-icons mdc-text-field__icon">alternate_email</i>
          <input v-model="form.email" type="email" class="mdc-text-field__input">
          <div class="mdc-notched-outline">
            <div class="mdc-notched-outline__leading"></div>
            <div class="mdc-notched-outline__notch">
              <label for="tf-outlined" class="mdc-floating-label">Эл. почта</label>
            </div>
            <div class="mdc-notched-outline__trailing"></div>
          </div>
        </div>
        <div class="mdc-text-field-helper-line">
          <div class="mdc-text-field-helper-text mdc-text-field-helper-text--persistent" aria-hidden="true">Мы отправим вам копию заказа.</div>
        </div>
      </div>
      <div class="input">
        <div ref="quantityTextfield" class="mdc-text-field mdc-text-field--outlined">
          <input v-model="form.quantity" type="number" pattern="[0-9]*" inputmode="numeric" class="mdc-text-field__input" required>
          <div class="mdc-notched-outline">
            <div class="mdc-notched-outline__leading"></div>
            <div class="mdc-notched-outline__notch">
              <label class="mdc-floating-label" required>Количество</label>
            </div>
            <div class="mdc-notched-outline__trailing"></div>
          </div>
        </div>
      </div>
      <div class="input">
        <button
          ref="submitButton"
          class="mdc-button mdc-button--unelevated"
        >
          <span class="mdc-button__label">Отправить заказ</span>
        </button>
      </div>
		<br><br>
</div>
  </div>
</div>
    </form>
    <footer v-show="ordersCount">{{ ordersCount }}</footer>
</div>
  </div>
</template>

<script>
import { MDCRipple } from '@material/ripple'
import { MDCTextField } from '@material/textfield'
import axios from 'axios'

export default {
  name: 'Order',

  data () {
    return {
      ordersCount: undefined,
      bookPrice: 500,
      deliveryPrice: 360,
      orderSended: undefined,
      form: {
        name: undefined,
        phone: undefined,
        email: undefined,
        quantity: 1
      }
    }
  },

  watch: {
    form: {
      deep: true,
      handler (form) {
        // Filter quantity
        let v = form.quantity
        if (v && parseInt(v) != v) {
          form.quantity = v.substring(0, v.length - 1)
        }
        if (v === '0') {
          form.quantity = ''
        }

        // Filter phone
        if (form.phone) {
          form.phone = form.phone.replace(/[^0-9\-()+ ]/g, '')
        }
      }
    }
  },

  methods: {
    sendOrder () {
      this.form.created = new Date()
      this.form.amount = this.bookPrice * parseInt(this.form.quantity)

      if (this.form.phone.length < 10) {
        this.phoneTextfield.valid = false
        this.phoneTextfield.focus()
      } else {
        // Send order info to shop & client
        // GET method selected coz of I dunno how to deal with old old old Laravel ;-\
        const f = this.form
        const qs = `name=${f.name}&phone=${f.phone}&email=${f.email}&quantity=${f.quantity}`
          + `&amount=${f.amount}&deliveryPrice=${this.deliveryPrice}`

        axios.get(`https://vilkova.ru/api/vilkova-book-order?${qs}`)
          .then(response => {
            if(response.data.code === 'OK') {
              this.orderSended = true
            }
          })
      }
    }
  },

  created () {
    axios.get(`https://vilkova.ru/api/vilkova-book-info`)
        .then(response => {
          if(response.data.code === 'OK') {
            this.ordersCount = response.data.ordersCount
          }
        });
		
		/*
		$element.bind('touchmove', function (e) {
			console.log(e.touches[0].pageY,e.touches[0].clientY);
		});*/
		/*
		window.onscroll = function() {
			var scrolled = window.pageYOffset || document.documentElement.scrollTop;
			console.log(scrolled);
		}
		*/
		
		
  },

  mounted () {
    this.closeButton1 = new MDCRipple(this.$refs.closeButton1)
    this.closeButton2 = new MDCRipple(this.$refs.closeButton2)
    this.nameTextfield = new MDCTextField(this.$refs.nameTextfield)
    this.phoneTextfield = new MDCTextField(this.$refs.phoneTextfield)
    this.emailTextfield = new MDCTextField(this.$refs.emailTextfield)
    this.quantityTextfield = new MDCTextField(this.$refs.quantityTextfield)
    this.submitButton = new MDCRipple(this.$refs.submitButton)

    this.closeButton1.unbounded = true
  },

  destroyed () {
    this.closeButton1.destroy()
    this.closeButton2.destroy()
    this.nameTextfield.destroy()
    this.phoneTextfield.destroy()
    this.emailTextfield.destroy()
    this.quantityTextfield.destroy()
    this.submitButton.destroy()
  }
}
</script>

<style lang="scss">
@import "~@/assets/theme";

@import "~@material/icon-button/mdc-icon-button";
@import "~@material/button/mdc-button";
@import "~@material/textfield/mdc-text-field";
@import "~@material/textfield/helper-text/mdc-text-field-helper-text";

.order {
  position: fixed;
  background-color: rgba($color: #ffffff, $alpha: 1);
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1000;
  padding: 0 0 1rem 1rem;
  height:100%;
  overflow: auto;
  /* 
  max-height:100vh;
  */
  
  }

  form, .order-sended-message {
    max-width: 550px;
    margin: 2rem auto 0 auto;
  }

  .order-sended-message {
    margin-top: 5rem;
    width: 90%;
  }

  p {
    margin: 1rem 0;
  }

  .input {
    margin-top: 1.5rem;
  }

  .mdc-text-field {
    width: 90%;
  }

  .mdc-icon-button--close {
    float: right;
  }

  footer {
    position: fixed;
    right: 10px;
    bottom: 1px;
    font-size: 80%;
    color: #ccc;
  }

</style>
