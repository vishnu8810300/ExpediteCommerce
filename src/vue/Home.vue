<template>
    <div class="opportunities-table">
      <h2>Opportunities</h2>
      <table class="grid-table">
        <thead>
          <tr>
            <th>Opportunity Name</th>
            <th>Stage</th>
            <th>Amount</th>
          </tr>
        </thead>
        <tbody>
          <!-- Parent row: Opportunity -->
          <tr v-for="opportunity in opportunities" :key="opportunity.Opportunity.Id">
            <td class="position-cell">
              <span @click="toggleExpand(opportunity.Opportunity.Id)">
                <span v-if="isExpanded(opportunity.Opportunity.Id)">▼</span>
                <span v-else>►</span> {{ opportunity.Opportunity.Name }}
              </span>
            </td>
            <td>{{ opportunity.Opportunity.StageName }}</td>
            <td>${{ opportunity.Opportunity.Amount }}</td>
          </tr>
  
          <!-- Nested Quotes under Opportunity -->
          <tr v-if="isExpanded(opportunity.Opportunity.Id)" v-for="quote in opportunity.Quotes" :key="quote.Quote.Id" class="quote-row">
            <td class="position-cell">
              <span @click="toggleExpand('quote-' + quote.Quote.Id)">
                <span v-if="isExpanded('quote-' + quote.Quote.Id)">▼</span>
                <span v-else>►</span> {{ quote.Quote.Name }}
              </span>
            </td>
            <td colspan="2">Total Price: ${{ quote.Quote.TotalPrice }}</td>
          </tr>
  
          <!-- Nested Quote Line Items under Quotes -->
          <tr v-if="isExpanded('quote-' + quote.Quote.Id)" v-for="item in quote.QuoteLineItems" :key="item.Id" class="line-item-row">
            <td class="position-cell">
              {{ item.Quantity }} x ${{ item.UnitPrice }} (Total: ${{ item.TotalPrice }})
            </td>
            <td colspan="2"></td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      opportunities: Array, // Array of opportunities with quotes and line items
    },
    data() {
      return {
        expandedRows: {}, // To track expanded rows
      };
    },
    methods: {
      toggleExpand(rowId) {
        this.$set(this.expandedRows, rowId, !this.expandedRows[rowId]);
      },
      isExpanded(rowId) {
        return !!this.expandedRows[rowId];
      }
    }
  };
  </script>
  
  <style scoped>
  /* Main table styling */
  .grid-table {
    width: 100%;
    border-collapse: collapse;
  }
  
  .grid-table th, .grid-table td {
    border: 1px solid #ddd;
    padding: 10px;
    text-align: left;
  }
  
  .position-cell {
    cursor: pointer;
  }
  
  .quote-row, .line-item-row {
    background-color: #f9f9f9;
  }
  
  .line-item-row td {
    padding-left: 30px; /* Indent for line items */
  }
  
  .quote-row td {
    padding-left: 20px; /* Indent for quotes */
  }
  </style>
  