import Chart from 'chart.js';

import ApplicationController from './application_controller';

export default class extends ApplicationController {
  static targets = [
    'overdueInspections'
  ];
  
  declare overdueInspectionsTarget: HTMLElement;
  
  connect() {
    super.connect();
    
    // Parse the overdue inspections data
    const overdueInspectionsData = JSON.parse(this.overdueInspectionsTarget.dataset.overdueInspectionsData);
    
    // Display the overdue inspections chart
    new Chart(this.overdueInspectionsTarget,
      {
        type: 'bar',
        data: {
          labels: overdueInspectionsData.labels,
          datasets: [
            {
              label: 'Overdue Inspections (%)',
              data: overdueInspectionsData.percentages,
              totalInspections: overdueInspectionsData.inspections,
              backgroundColor: 'rgba(11,98,164,1.0)'
            }
          ]
        },
        options: {
          legend: {
            display: false
          },
          responsive: true,
          scales: {
            yAxes: [
              {
                ticks: {
                  min: 0,
                  max: 100
                }
              }
            ]
          },
          tooltips: {
            callbacks: {
              footer: ([tooltipItem], data) => {
                return `Inspections: ${data.datasets[tooltipItem.datasetIndex].totalInspections[tooltipItem.index]}`;
              },
              label: (tooltipItem, data) => {
                return `Overdue: ${data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index]}%`;
              }
            }
          }
        }
      }  
    );
  }
}