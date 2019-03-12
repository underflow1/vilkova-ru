<template>
  <div id="app">
    <aside ref="drawer" class="mdc-drawer mdc-drawer--modal">
      <div class="mdc-drawer__content">
        <nav class="mdc-list">
          <span
            @click="gotoHome"
            class="mdc-list-item mdc-list-item--activated"
            aria-selected="true"
          >
            Обложка
          </span>
          <hr class="mdc-list-divider">
          <h6 class="mdc-list-group__subheader">Оглавление</h6>
          <span
            v-for="(o, i) in book"
            :key="`book-nav-${i}`"
            @click="gotoBook(i)"
            class="mdc-list-item"
          >
            {{ o.title }}
          </span>
        </nav>
      </div>
    </aside>
    <div class="mdc-drawer-scrim"></div>
    <div class="mdc-drawer-app-content">
      <header ref="topappbar" class="mdc-top-app-bar mdc-top-app-bar--prominent">
        <div class="mdc-top-app-bar__row">
          <section class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start">
            <span class="material-icons mdc-top-app-bar__navigation-icon">menu</span>
            <span class="mdc-top-app-bar__title">
              Ирина Вилкова
            </span>
          </section>
          <section class="mdc-top-app-bar__section mdc-top-app-bar__section--align-end" role="toolbar">
            <i
              @click="gotoOrder"
              class="material-icons mdc-top-app-bar__action-item"
              aria-label="Купить книгу"
              title="Купить книгу"
            >
              favorite
            </i>
          </section>
        </div>
      </header>
      <main ref="content" class="main-content">
        <div class="mdc-top-app-bar--prominent-fixed-adjust">
          <div class="mdc-layout-grid">
            <div class="mdc-layout-grid__inner">
              <div class="mdc-layout-grid__cell mdc-layout-grid__cell--span-4">
                <transition name="fade">
                  <router-view :key="$route.fullPath"/>
                </transition>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
    <!-- ORDER -->
    <transition name="fade">
      <order
        v-show="showOrder"
        @close="showOrder = false"
      />
    </transition>
  </div>
</template>

<script>
import { MDCTopAppBar } from '@material/top-app-bar'
import { MDCDrawer } from '@material/drawer'
import Order from '@/components/order'

export default {
  name: 'App',
  components: { Order },

  data () {
    return {
      book: this.$root.book,
      drawer: undefined,
      topAppBar: undefined,
      showOrder: false
    }
  },

  computed: {
    state () {
      return {
        home: (this.$route.name === 'home'),
        book: (this.$route.name === 'book'),
      }
    }
  },

  methods: {
    // Set active drawer item
    setActiveDrawerItem (i) {
      const items = document.querySelectorAll('.mdc-drawer .mdc-list-item')
      items.forEach(node => node.classList.remove('mdc-list-item--activated'))
      const index = (i && i < items.length) ? i : 0
      items[index].classList.add('mdc-list-item--activated')
    },
    gotoHome () {
      this.drawer.open = false
      this.$router.push('/')
      this.setActiveDrawerItem(0)
    },
    gotoOrder () {
      this.showOrder = true
    },

    gotoBook (index) {
      this.drawer.open = false
      this.$router.push(`/book/${index}`)
    }
  },

  mounted () {
    this.drawer = new MDCDrawer(this.$refs.drawer)
    this.topAppBar = new MDCTopAppBar(this.$refs.topappbar)
    this.topAppBar.setScrollTarget(this.$refs.content)
    this.topAppBar.listen('MDCTopAppBar:nav', () => (this.drawer.open = !this.drawer.open))
  },

  destroyed () {
    this.drawer.destroy()
    this.topAppBar.destroy()
  }
}
</script>

<style lang="scss">
@import "./assets/theme";

@import "~@material/layout-grid/mdc-layout-grid";
@import "~@material/typography/mdc-typography";
@import "~@material/top-app-bar/mdc-top-app-bar";
@import "~@material/drawer/mdc-drawer";
@import "~@material/list/mdc-list";

@import "./assets/app";

.fade-enter-active {
  transition: opacity .3s ease;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
