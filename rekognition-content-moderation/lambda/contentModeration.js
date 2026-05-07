const {
  RekognitionClient,
  DetectModerationLabelsCommand,
} = require('@aws-sdk/client-rekognition')

const rekognition = new RekognitionClient({})

const detectModeration = async (imgBytes) => {
  const confidenceData = []


   const command = new DetectModerationLabelsCommand(
  // TODO: remove code for testing purpose
  // {
  //   Image: {
  //     Bytes: Buffer.from(imgBytes, 'base64'),
  //   },
  //  }
   imgBytes
  )

  try {
    const response = await rekognition.send(command)
    //const response = require('./response.json') // TODO: remove code for testing purpose

    if (response.ModerationLabels) {
      for (const label of response.ModerationLabels) {
        if (label.Name && label.Confidence >= 95) {
          const confidence = `${label.Name} : ${label.Confidence.toFixed(2)}`
          console.log('Moderated image with confidence: ', confidence)
          confidenceData.push(confidence + '\n')
        }
      }
    }
  } catch (error) {
    console.error('Error detecting moderation labels:', error)
  }

  return confidenceData
}

exports.handler = async function(event, context, callback) {

  console.log(`[Lambda] Path: ${event}`)

  // BEGIN - For testing purpose, confirm bucket & key
  const bucket = 'image-moderation-test1'//event.Records[0].s3.bucket.name;
  const key = 'jernej-graj-WXeJQPimgag-unsplash.jpg' //event.Records[0].s3.object.key;
  const img = {
    Image: {
      S3Object: {
        Bucket: bucket,
        Name: key,
      },
    },
  };
  // END

  try {
      // Step 1 - detectModeration labels
      const detectedImagesWithModerationConfidenceLevel = await detectModeration(img)

      // Step 2 - store image to dedicated S3 bucket and alert specific team (email/slack)
      if (detectedImagesWithModerationConfidenceLevel.length > 0) {
        // TODO: store image in S3 bucket

        // TODO: alert team (later)
        const moderationAlert = detectedImagesWithModerationConfidenceLevel.join(
          ' '
        )
        console.log('moderationAlert', moderationAlert)
      }
    } catch (e) {
      console.log('ERROR', e.message)
    }
}
