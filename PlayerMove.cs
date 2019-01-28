using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayerMove : MonoBehaviour
{

    float jumpForce = 400f;

    private Rigidbody2D rb;

    float speed = 13f;

    public bool grounded = false;

    public Transform feet;

    public LayerMask whatIsGround;

    //public int jumps = 1;

    //private int maxJumps = 0;

    float jumpTime = 1;

    bool jumpPress = false;

    Vector2 lookLeft;

    Vector2 lookRight;

    public Transform hand;

    public float fireRate = 0.5f;

    private float nextRate = 0.5f;



   //public int dir = 1;

    public Animator anim;

    private float ySpeed;

    private float xSpeed;

    public GameObject Bullet;

    private SpriteRenderer Sr;

    private int direction = 1;


    private AudioSource source;

    public GameObject DeathSprite;

    public Vector3 respawnPoint;


   
    private float volLowRange = .8f;
    private float volHighRange = .9f;


    public AudioClip yuck;
    public AudioClip gross;
    public AudioClip die;






    // Use this for initialization
    void Start()
    {
        anim = GetComponent<Animator>();
        rb = GetComponent<Rigidbody2D>();
        lookRight = transform.localScale;
        lookLeft = new Vector2(-transform.localScale.x, transform.localScale.y);
        Sr = GetComponent<SpriteRenderer>();

        source = GetComponent<AudioSource>();



    }

    // Update is called once per frame
    void Update()
    {
      

        anim.SetFloat("Speed", Mathf.Abs(xSpeed));
        xSpeed = Input.GetAxisRaw("Horizontal") * speed;

        ySpeed = rb.velocity.y;

        anim.SetBool("Jump", !grounded);
       
        grounded = Physics2D.OverlapCircle(feet.position, 0.5f, whatIsGround);
        //if (grounded)
        //{
        //    jumps = maxJumps;
        //}


        if (Input.GetButton("Jump") && rb.velocity.y < 0)
        {

            anim.SetBool("jump", !grounded);
            ySpeed = 0;
        }

        if (Input.GetButtonDown("Jump") && grounded)
        {
            //jumps--;
           float vol = Random.Range(volLowRange, volHighRange);
           source.PlayOneShot(gross, vol);
            ySpeed = 0;
            jumpPress = true;
            jumpTime = Time.time;
        }

        if (Input.GetButtonUp("Jump"))
        {
            jumpPress = false;
        }


        if (xSpeed < 0)
        {
            Sr.flipX = true;
            direction = -1;
        }
        else if (xSpeed > 0)
        {
            Sr.flipX = false;
            direction = 1;
        }
        //rb.velocity = new Vector2(xSpeed, ySpeed);



        if (Input.GetButtonDown("Fire1") && Time.time > nextRate)
        {
            nextRate = Time.time + fireRate;
            float vol = Random.Range(volLowRange, volHighRange);
            source.PlayOneShot(yuck, vol);

            Vector2 spawnPos = new Vector2(transform.position.x + direction, transform.position.y);

            GameObject bulletPrefab = Instantiate(Bullet, transform.position, Quaternion.identity) as GameObject;

            bulletPrefab.GetComponent<SpriteRenderer>().flipX = Sr.flipX;
            bulletPrefab.GetComponent<Rigidbody2D>().AddForce(transform.right * 500 * direction);
            bulletPrefab.GetComponent<Rigidbody2D>().AddForce(transform.up * 800);


        }

    }

 




    void FixedUpdate()
    {
        if (jumpPress)
        {
            if (Time.time - jumpTime < .11f)
            {
                rb.AddForce(new Vector2(0, jumpForce));

            }
           
        }

        rb.velocity = new Vector2(xSpeed, ySpeed);

    }

 

 

    private void OnTriggerEnter2D(Collider2D col)
    {
        if (col.tag == "Enemy")
        {
            float vol = Random.Range(volLowRange, volHighRange);
            source.PlayOneShot(die, vol);
            transform.position = respawnPoint;
        }

             
        
    }


}

    


 