<template>
    <div id="app">
      <!--     Data from outer property: {{ title }}
        <br />
        <br />
        
        <ul ref="accountList">
            <li
                v-for="account in accounts"
                :key="account.Id"
                v-on:click="handleClick(account.Id)"
            >
                {{ account.Id }} - {{ account.Name }}
            </li>
        </ul>
    -->
      
        <Home :opportunities="accounts" />
    </div>
</template>

<script>
import getAccounts from "@salesforce/apex/AccountController.getAccounts";
import Home from './Home.vue';
export default {
    name: "App",
     components: {
    Home
  },
    props: {
        accounts: Array,
        title: String,
        opportunities: Array
    },
    data() {
      return {
        quote: Array,  // Tracks expanded quotes by ID
        theOppquote: Array,
        QuoteLineItem :Array
      };
    },
   
    methods: {
        handleClick: function (accountId) {
            const evt = new CustomEvent("sendaccount", {
                detail: { accountId },
                bubbles: true,
                composed: true
            });
            // Here we reference the `accountList` ref to dispatch the native event.
            this.$refs.accountList.dispatchEvent(evt);
        }
    },
    mounted: function () {
        getAccounts()
            .then((result) => (this.accounts = JSON.parse(result),
           

                console.log(this.accounts),
                setTimeout(() => {
                     this.opportunities =this.accounts.opportunities,
                     console.log('accounts-->', result ),
                console.log('accounts1-->',result.opportunities ),
                console.log('accounts2-->', this.accounts.opportunities ),
                console.log('accounts3-->', this.opportunities )
                },1000)
                
            ))
            .catch((error) => console.log(error));
    },
     watch: {
    accounts: {
        immediate: true,
        handler(newVal) {
    if (newVal && Array.isArray(newVal)) {
        this.opportunities = newVal;
    }
    }
    }
}
};
</script>

<style>
#app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: #2c3e50;
    padding: 6px;
}

li {
    cursor: pointer;
}
</style>
